import 'package:bloc/bloc.dart';
import 'package:bloc_clean_architecture/UIs/edit_todo/bloc/edit_todo_events.dart';
import 'package:bloc_clean_architecture/UIs/edit_todo/bloc/edit_todo_state.dart';
import 'package:bloc_clean_architecture/core/models/todo.dart';
import 'package:bloc_clean_architecture/core/repositories/todo_repository.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  final TodosRepository _todosRepository;
  EditTodoBloc(
      {required TodosRepository todosRepository, required Todo? initialTodo})
      : _todosRepository = todosRepository,
        super(EditTodoState(
          initialTodo: initialTodo,
          description: initialTodo?.description ?? '',
          title: initialTodo?.title ?? '',
        )) {
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
            const Todo(
              title: '',
            ))
        .copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
