import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/UIs/edit_todo/bloc/edit_todo_events.dart';
import 'package:bloc_clean_architecture/UIs/edit_todo/bloc/edit_todo_state.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  final TodosRepository _todosRepository;
  EditTodoBloc({required TodosRepository todosRepository})
      : _todosRepository = todosRepository,
        super(const EditTodoState()) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoSubmitted>(_onSubmitted);
  }

  Future<void> _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(title: event.title));
  }

  Future<void> _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ??
            Todo(
              title: '',
            ))
        .copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      print(todo.toJson());
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
