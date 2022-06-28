import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/UIs/stats/bloc/stats_events.dart';
import 'package:bloc_clean_architecture/UIs/stats/bloc/stats_states.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodosRepository _todosRepository;
  StatsBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }

  Future<void> _onSubscriptionRequested(
    StatsSubscriptionRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));
    await emit.onEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (data) => state.copyWith(
          status: StatsStatus.success,
          completedTodos: data.where((e) => e.isCompleted).length,
          activeTodos: data.where((e) => !e.isCompleted).length),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
