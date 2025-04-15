from django.http import JsonResponse
from .models import UserPath, Path, PopularPath, TaskPath, UserTaskAnswer, Task
from .serializers import PathSerializer, TaskSerializer, UserTaskAnswerSerializer
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from django.utils.decorators import method_decorator
from django.utils.timezone import now
from datetime import date, timedelta

@method_decorator(jwt_required, name='dispatch')
class UserPathsView(APIView):
    def get(self, request):
        user_paths_assignments = UserPath.objects.filter(user_id=request.user_id)
        user_paths = [Path.objects.get(id=assignment.path_id) for assignment in user_paths_assignments]
        paths_data = [{
            "title": user_path.title,
            "background_type": (
                "image" if user_path.image_url else
                "color" if user_path.color_hex else
                "default"
            ),
            "background_value": (
                user_path.image_url or
                user_path.color_hex or
                "#FFFFFF"
            )
        } for user_path in user_paths]
        return JsonResponse({"user_paths": paths_data})

@method_decorator(jwt_required, name='dispatch')
class PopularPathsView(APIView):
    def post(self, request):
        loaded_paths = request.data.get("loaded_paths_number")
        popular_paths_assignments = PopularPath.objects.all()[loaded_paths:loaded_paths+4]
        popular_paths = [Path.objects.get(id=assignment.path_id) for assignment in popular_paths_assignments]
        paths_data = [{
            "title": popular_path.title,
            "background_type": (
                "image" if popular_path.image_url else
                "color" if popular_path.color_hex else
                "default"
            ),
            "background_value": (
                popular_path.image_url or
                popular_path.color_hex or
                "#FFFFFF"
            )
        } for popular_path in popular_paths]
        return JsonResponse({"popular_paths": paths_data})


@method_decorator(jwt_required, name='dispatch')
class PathByTitleView(APIView):
    def get(self, request):
        title = request.GET.get("title")
        print(title)
        if not title:
            return Response({"error": "Brak parametru 'title'"}, status=400)
        try:
            path = Path.objects.get(title = title)
            path_tasks = [path_task.task for path_task in TaskPath.objects.filter(path_id = path.id)]
            path_assigned = UserPath.objects.filter(user_id = request.user_id, path_id = path.id).exists()
            user_tasks = {
                ut.task_id: ut
                for ut in UserTaskAnswer.objects.filter(task_id__in=[t.id for t in path_tasks], user_id=request.user_id)
            }
            path_serializer = PathSerializer(path)
            tasks_data = []
            for task in path_tasks:
                task_data = TaskSerializer(task).data
                user_task = user_tasks.get(task.id)
                if user_task:
                    task_data["status"] = user_task.status
                else:
                    task_data["status"] = "pending"
                tasks_data.append(task_data)
            data = {
                "path": path_serializer.data,
                "tasks": tasks_data,
                "is_saved": path_assigned
            }
            return JsonResponse(data, status=200)
        except Path.DoesNotExist:
            return JsonResponse({"error": "Path does not exist"}, status=404)

@method_decorator(jwt_required, name='dispatch')
class UserTaskAnswerView(APIView):
    def post(self, request):
        data = request.data
        if data.get("text_answer") or data.get("checkbox_answer"): 
            status = "completed" 
        else:
            status = "in_progress"
        answer, created = UserTaskAnswer.objects.update_or_create(
            user_id = request.user_id,
            task_id = data["task_id"],
            defaults = {
                'text_answer': data.get("text_answer"),
                'checkbox_answer': data.get("checkbox_answer"),
                'status': status,
                'answered_at': now()
            }

        )
        print(answer)
        return JsonResponse({"id": answer.id, "created": created, "status": "saved"}, status=200)

@method_decorator(jwt_required, name='dispatch')
class UserPathView(APIView):
    def post(self, request):
        title = request.data.get('path_title')
        print(title)
        path = Path.objects.get(title = title)
        user_path, created = UserPath.objects.get_or_create(user_id=request.user_id, path=path)

        if not created:
            user_path.delete()
            data = {"isSaved": False}
        else:
            data = {"isSaved": True}

        return JsonResponse(data, status=200)

@method_decorator(jwt_required, name='dispatch')
class StreakView(APIView):
    def get(self, request):
        try:
            today = date.today()
            streak = 0
            task_for_day = Task.objects.filter(date_for_daily=today).first()
            answered = UserTaskAnswer.objects.filter(
                user_id = request.user_id,
                task=task_for_day,
                status='completed'
            ).exists()

            print(answered)
            if answered:
                streak += 1
            today -= timedelta(days=1)

            while True:
                task_for_day = Task.objects.filter(date_for_daily=today).first()
                answered = UserTaskAnswer.objects.filter(
                    user_id = request.user_id,
                    task=task_for_day,
                    status='completed'
                ).exists()

                print(answered)
                if answered:
                    streak += 1
                    today -= timedelta(days=1)
                else:
                    break
            return JsonResponse({"streak": streak}, status=200)
        except Exception as e:
            print(e)
            return JsonResponse({"error": e}, status=400)

@method_decorator(jwt_required, name='dispatch')
class DailyTasksView(APIView):
    def get(self, request):
        try:
            today = date.today()
            start_date = today - timedelta(days=2)
            daily_tasks = Task.objects.filter(type="daily", date_for_daily__range=(start_date, today)).order_by("date_for_daily")
            tasks_dict = [
                    {
                        "id": task.id,
                        "title": task.title,
                        "description": task.description,
                        "date": task.date_for_daily.isoformat(),
                        "category": task.category,
                        "difficulty": task.difficulty,
                        "answer_type": task.answer_type,
                        "type": task.type,
                        "date_for_daily": task.date_for_daily,
                        "created_at": task.created_at,
                        "updated_at": task.updated_at,
                    }
                    for task in daily_tasks
                ]
            for task in tasks_dict:
                answer = UserTaskAnswer.objects.filter(user_id = request.user_id, task_id = task.get("id")).first()
                task["status"] = answer.status
            data = {"tasks": tasks_dict}
            print(data)
            return JsonResponse(data, status=200)
        except Exception as e:
            print(e)
            return JsonResponse({"error": e}, status=400)

@method_decorator(jwt_required, name='dispatch')
class DailyTasksStatusView(APIView):
    def get(self, request):
        try:
            daily_tasks_ids = Task.objects.filter(type="daily").values_list("id", flat=True)
            print(daily_tasks_ids)
            statuses = UserTaskAnswer.objects.filter(
                user_id=request.user_id, 
                task_id__in=daily_tasks_ids
                ).select_related('task')
            print(statuses)
            data = []
            for status in statuses:
                data.append({
                    "date": status.task.date_for_daily,
                    "status": status.status
                })
            print(data)
            return JsonResponse({"tasks": data}, status=200)
        except Exception as e:
            print(e)
            return JsonResponse({"error": e}, status=400)