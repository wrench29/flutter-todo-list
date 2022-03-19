import 'package:equatable/equatable.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class FetchTodos extends TodoEvent {
  final String account;

  const FetchTodos({required this.account});

  @override
  List<Object> get props => [];
}

class AddTodoPressed extends TodoEvent {
  final String text;
  final String account;

  const AddTodoPressed({required this.account, required this.text})
      : assert(text != "");

  @override
  List<Object> get props => [text];
}

class RemoveTodoPressed extends TodoEvent {
  final int index;
  final String account;

  const RemoveTodoPressed({required this.account, required this.index})
      : assert(index >= 0);

  @override
  List<Object> get props => [index];
}
