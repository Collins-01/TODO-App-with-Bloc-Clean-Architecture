import 'package:equatable/equatable.dart';

abstract class EditTodoEvent extends Equatable {
  const EditTodoEvent();
  @override
  List<Object?> get props => [];
}

class EditTodoTitleChanged extends EditTodoEvent {
  final String title;
  const EditTodoTitleChanged({required this.title});
  @override
  List<Object> get props => [title];
}

class EditTodoDescriptionChanged extends EditTodoEvent {
  final String description;
  const EditTodoDescriptionChanged({required this.description});
  @override
  List<Object> get props => [description];
}

class EditTodoSubmitted extends EditTodoEvent {
  const EditTodoSubmitted();
}
