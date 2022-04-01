import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/bloc/todo/todo_state.dart';
import 'package:testproject/models/todo_model.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/repos/todo_repo.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoRepository todoRepository;
  AuthRepository authRepository;

  TodoBloc(this.todoRepository, this.authRepository)
      : super(const TodoInitial()) {
    on<AddTodoPressed>(_onAddTodoPressed);
    on<RemoveTodoPressed>(_onRemoveTodoPressed);
    on<FetchTodos>(_onFetchTodos);
  }

  Future<void> _onFetchTodos(
    FetchTodos event,
    Emitter<TodoState> emitter,
  ) async {
    await todoRepository
        .readFromMemoryAndInitialize(authRepository.getCurrentUser());
    if (todoRepository
        .getTodoModelsList(authRepository.getCurrentUser())
        .isEmpty) {
      emitter(TodoChanged(const [], authRepository.getCurrentUser()));
      return;
    }
    emitter(const TodoInitial());

    emitter(TodoChanged(
        todoRepository.getTodoModelsList(authRepository.getCurrentUser()),
        authRepository.getCurrentUser()));
  }

  void _onAddTodoPressed(AddTodoPressed event, Emitter<TodoState> emitter) {
    if (event.text == "") {
      return;
    }

    todoRepository.addTodoModel(
        authRepository.getCurrentUser(), TodoModel(todoText: event.text));
    todoRepository.writeTodoListToMemory(authRepository.getCurrentUser());
    emitter(TodoChanged(
        todoRepository.getTodoModelsList(authRepository.getCurrentUser()),
        authRepository.getCurrentUser()));
  }

  void _onRemoveTodoPressed(
    RemoveTodoPressed event,
    Emitter<TodoState> emitter,
  ) {
    if (event.index >=
        todoRepository
            .getTodoModelsList(authRepository.getCurrentUser())
            .length) {
      return;
    }

    todoRepository.removeTodoModel(
        authRepository.getCurrentUser(), event.index);
    todoRepository.writeTodoListToMemory(authRepository.getCurrentUser());
    emitter(TodoChanged(
        todoRepository.getTodoModelsList(authRepository.getCurrentUser()),
        authRepository.getCurrentUser()));
  }
}
