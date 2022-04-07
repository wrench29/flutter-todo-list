import 'package:equatable/equatable.dart';

import 'package:testproject/models/category_model.dart';

abstract class CategoryState extends Equatable {
  final List<CategoryModel> categoryModelsList;
  final String username;

  const CategoryState(
      {required this.categoryModelsList, required this.username});

  @override
  List<Object> get props => categoryModelsList;
}

class CategoryInitial extends CategoryState {
  const CategoryInitial() : super(categoryModelsList: const [], username: "");
}

class CategoryChanged extends CategoryState {
  const CategoryChanged(List<CategoryModel> categoryModelsList, String username)
      : super(categoryModelsList: categoryModelsList, username: username);

  @override
  List<Object> get props => categoryModelsList;
}
