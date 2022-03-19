import 'package:equatable/equatable.dart';

import 'package:testproject/models/todo_model.dart';

abstract class TodoState extends Equatable {
  final List<TodoModel> todoModelsList;
  final String username;

  const TodoState({required this.todoModelsList, required this.username});

  @override
  List<Object> get props => todoModelsList;
}

class TodoInitial extends TodoState {
  const TodoInitial() : super(todoModelsList: const [], username: "");
}

class TodoChanged extends TodoState {
  const TodoChanged(List<TodoModel> todoModelsList, String username)
      : super(todoModelsList: todoModelsList, username: username);

  @override
  List<Object> get props => todoModelsList;
}
