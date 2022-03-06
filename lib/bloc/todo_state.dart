import 'package:equatable/equatable.dart';

import '../todo_model.dart';

abstract class TodoState extends Equatable {
  final TodoModel todoModel;

  const TodoState({required this.todoModel});

  @override
  List<Object> get props => [todoModel];
}

class TodoInitial extends TodoState {
  const TodoInitial() : super(todoModel: const TodoModel());
}

class TodoChanged extends TodoState {
  const TodoChanged(TodoModel todoModel) : super(todoModel: todoModel);

  @override
  List<Object> get props => [todoModel];
}
