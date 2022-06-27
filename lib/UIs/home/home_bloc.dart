import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_events.dart';
import 'package:bloc_clean_architecture/UIs/home/blocs/home_states.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';

class TodosHomeBloc extends Bloc<TodosOverviewEvent, TodoOverviewState> {
  final TodosRepository _todosRepository;
  TodosHomeBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const TodoOverviewState()) {
    on<TodosOverviewSubscriptionRequested>(_onSubscriptionRequested);
    on<TodoOverViewCompletionToggled>(_onTodoOverViewCompletionToggled);
  }

  Future<void> _onSubscriptionRequested(
    TodosOverviewSubscriptionRequested event,
    Emitter<TodoOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TodosOverviewStatus.loading));

    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TodosOverviewStatus.success,
        todos: () => todos,
      ),
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
}
