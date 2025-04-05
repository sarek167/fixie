from django.http import JsonResponse
from .models import UserPath, Path, PopularPath, TaskPath, UserTaskAnswer
from .serializers import PathSerializer, TaskSerializer, UserTaskAnswerSerializer
from utils.jwt_utils import decode_jwt
from utils.decorators import jwt_required
from rest_framework.views import APIView
from rest_framework.decorators import api_view
from django.utils.decorators import method_decorator
from django.utils.timezone import now

@method_decorator(jwt_required, name='dispatch')
class UserPathsView(APIView):
    def get(self, request):
        user_paths_assignments = UserPath.objects.filter(user_id=request.user_id)
        user_paths = [Path.objects.get(id=assignment.path_id) for assignment in user_paths_assignments]
        print(f"PATHS: {user_paths[0]}")
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
        print(paths_data)
        return JsonResponse({"user_paths": paths_data})

@method_decorator(jwt_required, name='dispatch')
class PopularPathsView(APIView):
    def get(self, request):
        popular_paths_assignments = PopularPath.objects.all()[:4]
        popular_paths = [Path.objects.get(id=assignment.path_id) for assignment in popular_paths_assignments]
        print(f"PATHS: {popular_paths[0]}")
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
        print(paths_data)
        return JsonResponse({"popular_paths": paths_data})


@method_decorator(jwt_required, name='dispatch')
class PathByTitleView(APIView):
    def get(self, request):
        title = request.GET.get("title")
        if not title:
            return Response({"error": "Brak parametru 'title'"}, status=400)
        try:
            path = Path.objects.get(title = title)
            path_tasks = [path_task.task for path_task in TaskPath.objects.filter(path_id = path.id)]
            user_tasks = {
                ut.task_id: ut
                for ut in UserTaskAnswer.objects.filter(task_id__in=[t.id for t in path_tasks], user_id=request.user_id)
            }
            print(path)
            print([path_task.title for path_task in path_tasks])
            print(user_tasks)
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
                "tasks": tasks_data
            }
            print(data)
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
            print("IN PROGRESS")
            print(data.get("text_answer"))
            status = "in_progress"
        print(f"STATUS: {status}")
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