import 'package:equatable/equatable.dart';

enum StatsStatus { initial, loading, success, failure }

class StatsState extends Equatable {
  final int completedTodos;
  final int activeTodos;
  final StatsStatus status;
  const StatsState(
      {this.activeTodos = 0,
      this.completedTodos = 0,
      this.status = StatsStatus.initial});
  @override
  List<Object?> get props => [activeTodos, completedTodos, status];

  StatsState copyWith({
    StatsStatus? status,
    int? completedTodos,
    int? activeTodos,
  }) {
    return StatsState(
      status: status ?? this.status,
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}
