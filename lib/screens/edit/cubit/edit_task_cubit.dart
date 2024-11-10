import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/data/data.dart';
import 'package:todo_list/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EditTaskCubit(this._task, this.repository)
      : super(EditTaskInitial(task: _task));

  void onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTitleTextChanged(String titleText) {
    _task.name = titleText;
  }

  void onDescriptionTextChanged(String descriptionText) {
    _task.description = descriptionText;
  }

  void onPriorityChanged(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChange(task: _task));
  }
}
