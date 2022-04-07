import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class FetchCategories extends CategoryEvent {
  const FetchCategories();

  @override
  List<Object> get props => [];
}

class AddCategoryPressed extends CategoryEvent {
  final String name;
  final Color color;

  const AddCategoryPressed({required this.name, required this.color});

  @override
  List<Object> get props => [name, color];
}

class RemoveCategoryPressed extends CategoryEvent {
  final int index;

  const RemoveCategoryPressed({required this.index}) : assert(index >= 0);

  @override
  List<Object> get props => [index];
}
