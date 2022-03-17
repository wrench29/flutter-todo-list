import 'package:equatable/equatable.dart';

import 'package:testproject/models/todo_model.dart';

abstract class TodoState extends Equatable {
  final List<TodoModel> todoModelsList;

  const TodoState({required this.todoModelsList});

  @override
  List<Object> get props => todoModelsList;
}

class TodoInitial extends TodoState {
  const TodoInitial() : super(todoModelsList: const []);
}

class TodoChanged extends TodoState {
  const TodoChanged(List<TodoModel> todoModelsList)
      : super(todoModelsList: todoModelsList);

  @override
  List<Object> get props => todoModelsList;
}
