import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class CategoryModel extends Equatable {
  const CategoryModel({
    this.id = 0,
    this.categoryName = "",
    this.color = const Color.fromARGB(255, 255, 255, 255),
  });

  final int id;
  final String categoryName;
  final Color color;

  @override
  List<Object> get props => [id, categoryName, color];
}
