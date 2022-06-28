import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_events.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';

class TodosOverviewBloc extends Bloc<TodosOverviewEvent, TodoOverviewState> {
  final TodosRepository _todosRepository;
  TodosOverviewBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodoOverviewState()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodoOverViewCompletionToggled>(_onTodoOverViewCompletionToggled);
    on<TodoOverviewDeleted>(_onTodoDeleted);
    on<TodosOverviewUndoDeletionRequested>(_onUndoDeleteRequested);
    on<TodosOverviewFilterChanged>(_onFilterChanged);
    on<TodoOverviewToggleAllRequested>(_onToggleAllRequested);
    on<TodosOverviewClearCompletedRequested>(_onClearCompletedRequest);
  }

  /// [_onSubscriptionRequested] returns a list of [Todo] to our UI when requested.
  /// emits [loading] indicator while the activty is being carried out.
  /// emits [failure] when an error occurs from the [Todo Repository]
  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodoOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));
    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) {
        return state.copyWith(
          status: () => TodosOverviewStatus.success,
          todos: () => todos,
        );
      },
      onError: (_, __) => state.copyWith(
        status: () => TodosOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onTodoOverViewCompletionToggled(
    TodoOverViewCompletionToggled event,
    Emitter<TodoOverviewState> emit,
  ) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> _onTodoDeleted(
    TodoOverviewDeleted event,
    Emitter<TodoOverviewState> emit,
  ) async {
    emit(state.copyWith(lastDeletedTodo: () => event.todo));
    final item = event.todo;
    await _todosRepository.deleteTodo(item.id);
  }

  Future<void> _onUndoDeleteRequested(
    TodosOverviewUndoDeletionRequested event,
    Emitter<TodoOverviewState> emit,
  ) async {
    assert(state.lastDeletedTodo != null, 'last deleted TODO can not be null');
    final lastTodo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: () => null));
    await _todosRepository.saveTodo(lastTodo);
  }

  Future<void> _onFilterChanged(
    TodosOverviewFilterChanged event,
    Emitter<TodoOverviewState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }

  Future<void> _onToggleAllRequested(
    TodoOverviewToggleAllRequested event,
    Emitter<TodoOverviewState> emit,
  ) async {
    final allAreCompleted = state.todos.every((element) => element.isCompleted);
    await _todosRepository.completeAll(isCompleted: !allAreCompleted);
  }

  Future<void> _onClearCompletedRequest(
    TodosOverviewClearCompletedRequested event,
    Emitter<TodoOverviewState> emit,
  ) async {
    await _todosRepository.clearCompleted();
  }
}
