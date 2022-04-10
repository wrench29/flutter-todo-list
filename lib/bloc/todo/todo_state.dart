import 'package:equatable/equatable.dart';
import 'package:testproject/models/category_model.dart';

import 'package:testproject/models/todo_model.dart';

abstract class TodoState extends Equatable {
  final List<TodoModel> todoModelsList;
  final List<CategoryModel> categoryModelsList;
  final String username;

  const TodoState(
      {required this.todoModelsList,
      required this.username,
      required this.categoryModelsList});

  CategoryModel getCategoryById(int id) {
    CategoryModel model = const CategoryModel();
    for (final CategoryModel category in categoryModelsList) {
      if (category.id == id) {
        model = category;
      }
    }
    return model;
  }

  @override
  List<Object> get props => [todoModelsList, username, categoryModelsList];
}

class TodoInitial extends TodoState {
  const TodoInitial()
      : super(
          todoModelsList: const [],
          username: "",
          categoryModelsList: const [],
        );
}

class TodoChanged extends TodoState {
  const TodoChanged(
    List<TodoModel> todoModelsList,
    String username,
    List<CategoryModel> categoryModelsList,
  ) : super(
          todoModelsList: todoModelsList,
          username: username,
          categoryModelsList: categoryModelsList,
        );

  @override
  List<Object> get props => [todoModelsList, username, categoryModelsList];
}
