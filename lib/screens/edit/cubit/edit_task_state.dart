part of 'edit_task_cubit.dart';

@immutable
sealed class EditTaskState {
  final TaskEntity task;

  const EditTaskState({required this.task});
}

final class EditTaskInitial extends EditTaskState {
  const EditTaskInitial({required super.task});
}

final class EditTaskPriorityChange extends EditTaskState {
  const EditTaskPriorityChange({required super.task});
}
