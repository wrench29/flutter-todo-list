import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/models/todo_model.dart';
import 'package:testproject/file.dart';
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
    final content = await readContent();
    final todoTexts = state.todoModel.todoTexts + content.split("\n");
    emitter(TodoChanged(state.todoModel.copyWith(todoTexts: todoTexts)));
  }

  void _onAddTodoPressed(AddTodoPressed event, Emitter<TodoState> emitter) {
    if (event.text == "") {
      return;
    }

    TodoModel newModel = state.todoModel
        .copyWith(todoTexts: state.todoModel.todoTexts + [event.text]);
    emitter(TodoChanged(newModel));
  }

  void _onRemoveTodoPressed(
    RemoveTodoPressed event,
    Emitter<TodoState> emitter,
  ) {
    if (event.index >= state.todoModel.todoTexts.length) {
      return;
    }

    List<String> newList = List.from(state.todoModel.todoTexts);
    newList.removeAt(event.index);
    TodoModel newModel = state.todoModel.copyWith(todoTexts: newList);
    emitter(TodoChanged(newModel));
  }
}
