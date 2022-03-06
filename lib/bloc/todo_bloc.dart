import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/todo_event.dart';
import 'package:testproject/todo_model.dart';

import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoInitial()) {
    on<TodoEvent>((event, emitter) => {
          if (event is AddTodoPressed)
            _onAddTodoPressed(event, emitter)
          else if (event is RemoveTodoPressed)
            _onRemoveTodoPressed(event, emitter)
        });
  }

  void _onAddTodoPressed(AddTodoPressed event, Emitter<TodoState> emitter) {
    if (event.text == "") {
      emitter(state);
      return;
    }

    TodoModel newModel = state.todoModel
        .copyWith(todoTexts: state.todoModel.todoTexts + [event.text]);

    emitter(TodoChanged(newModel));
  }

  void _onRemoveTodoPressed(
      RemoveTodoPressed event, Emitter<TodoState> emitter) {
    if (event.index >= state.todoModel.todoTexts.length) {
      emitter(state);
      return;
    }

    List<String> newList = List.from(state.todoModel.todoTexts);

    newList.removeAt(event.index);

    TodoModel newModel = state.todoModel.copyWith(todoTexts: newList);

    emitter(TodoChanged(newModel));
  }
}
