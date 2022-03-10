import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class FetchTodos extends TodoEvent {
  @override
  List<Object> get props => [];
}

class AddTodoPressed extends TodoEvent {
  final String text;

  const AddTodoPressed({required this.text}) : assert(text != "");

  @override
  List<Object> get props => [text];
}

class RemoveTodoPressed extends TodoEvent {
  final int index;

  const RemoveTodoPressed({required this.index}) : assert(index >= 0);

  @override
  List<Object> get props => [index];
}
