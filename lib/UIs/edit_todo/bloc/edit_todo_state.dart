import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:equatable/equatable.dart';

enum EditTodoStatus { initial, loading, success, failure }

extension EditTodoStatusX on EditTodoStatus {
  bool get isLoadingOrSuccess => [
        EditTodoStatus.loading,
        EditTodoStatus.success,
      ].contains(this);
}

class EditTodoState extends Equatable {
  final Todo? initialTodo;
  final String title;
  final EditTodoStatus status;
  final String description;
  const EditTodoState({
    this.description = '',
    this.initialTodo,
    this.title = '',
    this.status = EditTodoStatus.initial,
  });
  bool get isNewTodo => initialTodo == null;
  @override
  List<Object?> get props => [title, description, initialTodo, status];

  EditTodoState copyWith(
      {String? description,
      String? title,
      EditTodoStatus? status,
      Todo? initialTodo}) {
    return EditTodoState(
      description: description ?? this.description,
      status: status ?? this.status,
      title: title ?? this.title,
      initialTodo: initialTodo ?? this.initialTodo,
    );
  }
}
