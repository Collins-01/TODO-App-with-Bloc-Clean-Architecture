import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:equatable/equatable.dart';

enum HomeTab { todos, stats }
enum TodosOverviewStatus { initial, loading, success, failure }
enum TodosViewFilter { all, activeOnly, completedOnly }

class HomeState extends Equatable {
  final HomeTab tab;
  const HomeState({this.tab = HomeTab.todos});
  @override
  List<Object?> get props => [tab];
}

class TodoOverviewState extends Equatable {
  final TodosOverviewStatus status;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;
  const TodoOverviewState({
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
    this.status = TodosOverviewStatus.initial,
    this.todos = const [],
  });
  @override
  List<Object?> get props => [todos, status, filter, lastDeletedTodo];
  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TodoOverviewState copyWith({
    TodosOverviewStatus Function()? status,
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodoOverviewState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo:
          lastDeletedTodo != null ? lastDeletedTodo() : this.lastDeletedTodo,
    );
  }
}

extension TodosViewFilterX on TodosViewFilter {
  bool apply(Todo todo) {
    switch (this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}
