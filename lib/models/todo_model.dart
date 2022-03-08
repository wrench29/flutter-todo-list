import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({this.todoTexts = const []});

  final List<String> todoTexts;

  TodoModel copyWith({List<String>? todoTexts}) {
    return TodoModel(todoTexts: todoTexts ?? []);
  }

  @override
  List<Object> get props => [todoTexts];
}
