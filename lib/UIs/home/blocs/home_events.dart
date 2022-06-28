import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:equatable/equatable.dart';

/// Major Todos OverView Events for the homepage.
abstract class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object> get props => [];
}

class TodoOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodoOverviewToggleAllRequested();
}

class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequested();
}

class TodoOverViewCompletionToggled extends TodosOverviewEvent {
  final Todo todo;
  final bool isCompleted;
  const TodoOverViewCompletionToggled(
      {required this.isCompleted, required this.todo});
  @override
  List<Object> get props => [todo, isCompleted];
}

class TodoOverviewDeleted extends TodosOverviewEvent {
  final Todo todo;
  const TodoOverviewDeleted({required this.todo});
  @override
  List<Object> get props => [todo];
}

class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}
