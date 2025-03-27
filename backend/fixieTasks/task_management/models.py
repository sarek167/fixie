from django.db import models


class Task(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    category = models.CharField(max_length=100, blank=True, null=True)
    difficulty = models.IntegerField(blank=True, null=True)
    type = models.CharField(max_length=50, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title

    class Meta:
        db_table = "tasks"


class Path(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.title
        
    class Meta:
        db_table = "paths"


class TaskPath(models.Model):
    task = models.ForeignKey(Task, on_delete=models.CASCADE, related_name='path_assignments')
    path = models.ForeignKey(Path, on_delete=models.CASCADE, related_name='task_assignments')

    def __str__(self):
        return f'{self.task.title} in {self.path.title}'

    class Meta:
        db_table = "task_path"


class UserTask(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
        ('skipped', 'Skipped'),
    ]

    user_id = models.IntegerField()
    task = models.ForeignKey(Task, on_delete=models.CASCADE, related_name='user_tasks')
    status = models.CharField(max_length=50, choices=STATUS_CHOICES)
    assigned_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'Task {self.task.id} for user {self.user_id}'

    class Meta:
        db_table = "user_tasks"


class PopularPath(models.Model):
    path = models.ForeignKey(Path, on_delete=models.CASCADE, related_name='popular_entries')

    def __str__(self):
        return f'Popular Path: {self.path.title}'

    class Meta:
        db_table = "popular_paths"

class UserPath(models.Model):
    user_id = models.IntegerField()
    path = models.ForeignKey(Path, on_delete=models.CASCADE, related_name='user_paths')
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'User {self.user_id} in path {self.path.title}'

    class Meta:
        db_table = "user_paths"

