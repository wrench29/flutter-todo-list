import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({this.todoText = ""});

  final String todoText;

  @override
  String toString() {
    return todoText;
  }

  @override
  List<Object> get props => [todoText];
}
