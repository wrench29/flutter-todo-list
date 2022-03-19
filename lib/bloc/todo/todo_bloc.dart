import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/models/todo_model.dart';
import 'package:testproject/repos/todo_repo.dart';

import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoRepository todoRepository;

  TodoBloc(this.todoRepository) : super(const TodoInitial()) {
    on<AddTodoPressed>(_onAddTodoPressed);
    on<RemoveTodoPressed>(_onRemoveTodoPressed);
    on<FetchTodos>(_onFetchTodos);
  }

  Future<void> _onFetchTodos(
    FetchTodos event,
    Emitter<TodoState> emitter,
  ) async {
    await todoRepository.readFromMemoryAndInitialize(event.account);
    if (todoRepository.getTodoModelsList(event.account).isEmpty) {
      return;
    }
    emitter(TodoChanged(todoRepository.getTodoModelsList(event.account)));
  }

  void _onAddTodoPressed(AddTodoPressed event, Emitter<TodoState> emitter) {
    if (event.text == "") {
      return;
    }

    todoRepository.addTodoModel(event.account, TodoModel(todoText: event.text));
    todoRepository.writeTodoListToMemory(event.account);
    emitter(TodoChanged(todoRepository.getTodoModelsList(event.account)));
  }

  void _onRemoveTodoPressed(
    RemoveTodoPressed event,
    Emitter<TodoState> emitter,
  ) {
    if (event.index >= todoRepository.getTodoModelsList(event.account).length) {
      return;
    }

    todoRepository.removeTodoModel(event.account, event.index);
    todoRepository.writeTodoListToMemory(event.account);
    emitter(TodoChanged(todoRepository.getTodoModelsList(event.account)));
  }
}
