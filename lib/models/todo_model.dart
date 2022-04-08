import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({this.todoText = "", required this.categoryId});

  final String todoText;
  final int categoryId;

  TodoModel.fromJson(Map<String, dynamic> json)
      : todoText = json['todoText'],
        categoryId = json['categoryId'];

  static Map<String, dynamic> toJson(TodoModel value) =>
      {'todoText': value.todoText, 'categoryId': value.categoryId};

  @override
  List<Object> get props => [todoText];
}
