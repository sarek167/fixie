import json
import pytest
from datetime import date, timedelta
from unittest.mock import MagicMock, patch

from django.test import RequestFactory
from rest_framework.test import APIRequestFactory

from task_management.models import (
    Path, PopularPath, Task, TaskPath, UserPath, UserTaskAnswer
)
from task_management.views import (
    UserPathsView, PopularPathsView, PathByTitleView, UserTaskAnswerView,
    UserPathView, StreakView, DailyTasksView, DailyTasksStatusView
)

from hypothesis import given, settings as hy_settings, strategies as st, assume
from hypothesis import HealthCheck

pytestmark = pytest.mark.django_db

@pytest.fixture
def rf():
    return RequestFactory()

@pytest.fixture
def apirf():
    return APIRequestFactory()

def create_path(title="P", img=True, color=False):
    return Path.objects.create(
        title=title,
        description="desc",
        image_url=("x.jpg" if img else ""),
        color_hex=("#ABCDEF" if color else "")
    )

def create_task(title="T", ttype="daily", d=None):
    return Task.objects.create(
        title=title, description="...",
        type=ttype,
        date_for_daily=d,
        answer_type="checkbox"
    )

def test_user_paths_view_returns_backgrounds(rf):
    p1 = create_path(title="A", img=True, color=False)
    p2 = create_path(title="B", img=False, color=True)
    p3 = create_path(title="C", img=False, color=False)

    for p in [p1, p2, p3]:
        UserPath.objects.create(user_id=10, path=p)

    req = rf.get("/api/user-paths/")
    req.user_id = 10
    resp = UserPathsView().get(req)

    assert resp.status_code == 200
    data = json.loads(resp.content)["user_paths"]
    assert {d["title"] for d in data} == {"A", "B", "C"}

    bt = {d["title"]: d["background_type"] for d in data}
    bv = {d["title"]: d["background_value"] for d in data}
    assert bt["A"] == "image" and bv["A"] == "x.jpg"
    assert bt["B"] == "color" and bv["B"] == "#ABCDEF"
    assert bt["C"] == "default" and bv["C"] == "#FFFFFF"


@hy_settings(deadline=None, suppress_health_check=[HealthCheck.too_slow], max_examples=25)
@given(loaded=st.integers(min_value=0, max_value=10))
def test_popular_paths_view_returns_sliced(loaded):
    # bez fixtur, wszystko lokalnie (Hypothesis-friendly)
    rf = RequestFactory()
    paths = [create_path(title=f"P{i}", img=(i % 2 == 0), color=(i % 3 == 0)) for i in range(7)]
    for p in paths:
        PopularPath.objects.create(path=p)

    req = rf.post("/api/popular-paths/", data=json.dumps({"loaded_paths_number": loaded}),
                  content_type="application/json")
    req.user_id = 1
    req.data = {"loaded_paths_number": loaded} 
    resp = PopularPathsView().post(req)
    assert resp.status_code == 200
    lst = json.loads(resp.content)["popular_paths"]
    assert isinstance(lst, list)
    assert len(lst) <= 4


def test_path_by_title_view_found_with_statuses(rf):
    p = create_path(title="Mindfulness")
    t1 = create_task(title="Breath", ttype="path")
    t2 = create_task(title="Walk", ttype="path")
    TaskPath.objects.create(task=t1, path=p)
    TaskPath.objects.create(task=t2, path=p)

    UserPath.objects.create(user_id=5, path=p)

    UserTaskAnswer.objects.create(user_id=5, task=t1, status="completed")

    req = rf.get(f"/api/path-by-title/?title={p.title}")
    req.user_id = 5


    with patch("task_management.views.PathSerializer") as MockPathSer, \
         patch("task_management.views.TaskSerializer") as MockTaskSer:
        MockPathSer.return_value.data = {"title": p.title}
        def _task_data(task):
            return {"id": task.id, "title": task.title}
        MockTaskSer.side_effect = lambda t: type("S", (), {"data": _task_data(t)})()

        resp = PathByTitleView().get(req)

    assert resp.status_code == 200
    payload = json.loads(resp.content)
    assert payload["is_saved"] is True
    titles = [t["title"] for t in payload["tasks"]]
    assert set(titles) == {"Breath", "Walk"}
    status_map = {t["title"]: t["status"] for t in payload["tasks"]}
    assert status_map["Breath"] == "completed"
    assert status_map["Walk"] == "pending"

def test_path_by_title_view_missing_param(rf):
    req = rf.get("/api/path-by-title/")
    req.user_id = 1
    resp = PathByTitleView().get(req)
    assert resp.status_code == 400
    assert json.loads(resp.content)["error"] == "Brak parametru 'title'"

def test_path_by_title_view_not_found(rf):
    req = rf.get("/api/path-by-title/?title=Nope")
    req.user_id = 1
    resp = PathByTitleView().get(req)
    assert resp.status_code == 404
    assert json.loads(resp.content)["error"] == "Path does not exist"

def test_user_task_answer_in_progress_no_kafka(rf):
    t = create_task(ttype="path")
    req = rf.post("/api/user-task-answer/", data=json.dumps({"task_id": t.id}),
                  content_type="application/json")
    req.user_id = 9
    req.data = {"task_id": t.id}
    with patch("task_management.views.producer", MagicMock()) as fake_prod:
        resp = UserTaskAnswerView().post(req)
        assert resp.status_code == 200
        fake_prod.send.assert_not_called()


@hy_settings(deadline=None, max_examples=20)
@given(
    text_answer=st.one_of(st.none(), st.text(min_size=1, max_size=20)),
    checkbox_answer=st.one_of(st.none(), st.just(True)),
)
def test_user_task_answer_completed_triggers_kafka(text_answer, checkbox_answer):
    assume((text_answer is not None and text_answer != "") or checkbox_answer is True)

    rf = APIRequestFactory()
    t = create_task(ttype="path")
    payload = {"task_id": t.id}
    if text_answer is not None:
        payload["text_answer"] = text_answer
    if checkbox_answer is not None:
        payload["checkbox_answer"] = checkbox_answer

    module_path = UserTaskAnswerView.__module__

    with patch(f"{module_path}.producer", MagicMock()) as fake_prod, \
         patch("utils.decorators.decode_jwt", return_value={"user_id": 7}):
        req = rf.post("/api/user-task-answer/", payload, format="json",
                      HTTP_AUTHORIZATION="Bearer test")
        resp = UserTaskAnswerView.as_view()(req)

    assert resp.status_code == 200
    topics = [c.args[0] for c in fake_prod.send.call_args_list]
    assert "task-completed-event" in topics
    
def test_user_task_answer_path_completion_triggers_path_event(rf):
    p = create_path("Mindfulness")
    t1 = create_task("Breath", "path")
    t2 = create_task("Walk", "path")
    TaskPath.objects.create(task=t1, path=p)
    TaskPath.objects.create(task=t2, path=p)

    UserTaskAnswer.objects.create(user_id=3, task=t1, status="completed")

    fake_producer = MagicMock()
    with patch("task_management.views.producer", fake_producer):
        payload = {"task_id": t2.id, "checkbox_answer": True}
        req = rf.post("/api/user-task-answer/", data=json.dumps({"task_id": t2.id, "checkbox_answer": True}),
                      content_type="application/json")
        req.user_id = 3
        req.data = payload
        
        resp = UserTaskAnswerView().post(req)
    assert resp.status_code == 200

    sent_topics = [c.args[0] for c in fake_producer.send.call_args_list]
    assert "task-completed-event" in sent_topics
    assert "path-completed-event" in sent_topics


def test_user_path_toggle_save_and_unsave(rf):
    p = create_path("Journey")
    req = rf.post("/api/user-path/", data=json.dumps({"path_title": p.title}),
                  content_type="application/json")
    req.user_id = 2
    req.data = {"path_title": p.title}

    resp1 = UserPathView().post(req)
    assert resp1.status_code == 200
    assert json.loads(resp1.content)["isSaved"] is True

    resp2 = UserPathView().post(req)
    assert resp2.status_code == 200
    assert json.loads(resp2.content)["isSaved"] is False


@hy_settings(deadline=None, max_examples=20,
             suppress_health_check=[HealthCheck.too_slow])
@given(
    done_today=st.booleans(),
    n=st.integers(min_value=1, max_value=6)
)
def test_streak_view_counts_consecutive_days(done_today, n):
    rf = RequestFactory()
    today = date.today()

    uid = 20_000 + (1 if done_today else 0) * 100 + n

    Task.objects.filter(date_for_daily__range=(today - timedelta(days=20), today)).delete()
    UserTaskAnswer.objects.filter(user_id=uid).delete()

    if done_today:
        for i in range(n):
            task = create_task(f"D{i}", "daily", today - timedelta(days=i))
            UserTaskAnswer.objects.create(user_id=uid, task=task, status="completed")
        create_task("break", "daily", today - timedelta(days=n))
    else:
        create_task("break-today", "daily", today)
        for i in range(1, n + 1):
            task = create_task(f"D{i}", "daily", today - timedelta(days=i))
            UserTaskAnswer.objects.create(user_id=uid, task=task, status="completed")
        create_task("break", "daily", today - timedelta(days=n + 1))

    with patch("task_management.views.producer", MagicMock()):
        req = rf.get("/api/streak")
        req.user_id = uid
        resp = StreakView().get(req)

    assert resp.status_code == 200
    assert json.loads(resp.content)["streak"] == n


def test_streak_yesterday_done_today_empty_counts_as_one():
    rf = RequestFactory()
    today = date.today()
    uid = 42

    Task.objects.filter(date_for_daily__in=[today, today - timedelta(days=1)]).delete()
    UserTaskAnswer.objects.filter(user_id=uid).delete()

    create_task("today", "daily", today)
    t_y = create_task("yesterday", "daily", today - timedelta(days=1))
    UserTaskAnswer.objects.create(user_id=uid, task=t_y, status="completed")

    with patch("task_management.views.producer", MagicMock()):
        req = rf.get("/api/streak")
        req.user_id = uid
        resp = StreakView().get(req)

    assert resp.status_code == 200
    assert json.loads(resp.content)["streak"] == 1

def test_daily_tasks_view_get_returns_last_three_days_with_statuses(rf):
    today = date.today()

    t0 = create_task("D0", "daily", today - timedelta(days=2))
    t1 = create_task("D1", "daily", today - timedelta(days=1))
    t2 = create_task("D2", "daily", today)
    UserTaskAnswer.objects.create(user_id=8, task=t1, status="completed")

    req = rf.get("/api/daily-tasks")
    req.user_id = 8
    resp = DailyTasksView().get(req)
    assert resp.status_code == 200
    tasks = json.loads(resp.content)["tasks"]
    assert [t["title"] for t in tasks] == ["D0", "D1", "D2"]
    st_map = {t["title"]: t["status"] for t in tasks}
    assert st_map["D0"] == ""
    assert st_map["D1"] == "completed"
    assert st_map["D2"] == ""

def test_daily_tasks_view_post_returns_task_by_date_with_serializer_patch():
    d = date.today()
    t = create_task("One", "daily", d)

    with patch("task_management.views.TaskSerializer") as MockTaskSer, \
         patch("utils.decorators.decode_jwt", return_value={"user_id": 4}):
        MockTaskSer.return_value.data = {"id": t.id, "title": t.title}

        rf = APIRequestFactory()
        req = rf.post(
            "/api/daily-tasks/",
            {"date": d.isoformat()},
            format="json",
            HTTP_AUTHORIZATION="Bearer test",
        )
        resp = DailyTasksView.as_view()(req)

    assert resp.status_code == 200
    assert json.loads(resp.content)["title"] == "One"

def test_daily_tasks_view_post_missing_date_401(rf):
    req = rf.post("/api/daily-tasks/", data=json.dumps({}), content_type="application/json")
    req.user_id = 4
    req.data = {}
    resp = DailyTasksView().post(req)
    assert resp.status_code == 401

def test_daily_tasks_view_post_wrong_date_404(rf):
    payload = {"date": "1900-01-01"}
    req = rf.post("/api/daily-tasks/", data=json.dumps(payload), content_type="application/json")
    req.user_id = 4
    req.data = payload
    resp = DailyTasksView().post(req)
    assert resp.status_code == 404


def test_daily_tasks_status_view_returns_all(rf):
    t1 = create_task("D1", "daily", date.today())
    t2 = create_task("D2", "daily", date.today() - timedelta(days=1))
    UserTaskAnswer.objects.create(user_id=6, task=t1, status="completed")
    UserTaskAnswer.objects.create(user_id=6, task=t2, status="in_progress")

    req = rf.get("/api/daily-tasks-status")
    req.user_id = 6
    resp = DailyTasksStatusView().get(req)
    assert resp.status_code == 200
    data = json.loads(resp.content)["tasks"]
    assert len(data) == 2
    assert {tuple(sorted(d.keys())) for d in data} == {("date", "status")}


def test_jwt_required_missing_token_401(apirf):
    resp = UserPathsView.as_view()(apirf.get("/api/user-paths/"))
    assert resp.status_code == 401
    assert json.loads(resp.content) == {"error": "Token not found"}

def test_jwt_required_invalid_token_401(apirf):
    with patch("utils.decorators.decode_jwt", side_effect=ValueError("Incorrect token")):
        req = apirf.get("/api/user-paths/", HTTP_AUTHORIZATION="Bearer bad")
        resp = UserPathsView.as_view()(req)
    assert resp.status_code == 401
    assert json.loads(resp.content) == {"error": "Incorrect token"}

def test_jwt_required_valid_token_sets_user_id_and_allows(apirf):
    with patch("utils.decorators.decode_jwt", return_value={"user_id": 123}):
        req = apirf.get("/api/user-paths/", HTTP_AUTHORIZATION="Bearer good")
        resp = UserPathsView.as_view()(req)
    assert resp.status_code == 200
    assert json.loads(resp.content) == {"user_paths": []}
