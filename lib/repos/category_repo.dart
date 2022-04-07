import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

import 'package:testproject/models/category_model.dart';
import 'package:testproject/utils.dart';

class CategoryRepository {
  final Map<String, List<CategoryModel>> _mapCategoryLists = {};

  List<CategoryModel> getCategoryModelsList(String account) {
    if (_mapCategoryLists[account] == null) {
      return [];
    }
    return [..._mapCategoryLists[account]!];
  }

  void addCategoryModel(String account, String name, Color color) {
    if (_mapCategoryLists[account] == null) {
      return;
    }
    int newId = 0;
    if (_mapCategoryLists[account]!.isNotEmpty) {
      newId =
          _mapCategoryLists[account]![_mapCategoryLists[account]!.length - 1]
                  .id +
              1;
    }
    _mapCategoryLists[account]!
        .add(CategoryModel(categoryName: name, color: color, id: newId));
  }

  void removeCategoryModel(String account, int index) {
    if (_mapCategoryLists[account] == null) {
      return;
    }
    if (index > _mapCategoryLists[account]!.length) {
      throw RangeError("Trying to access undefined member of categoryList");
    }
    _mapCategoryLists[account]!.removeAt(index);
  }

  Future<void> readFromMemoryAndInitialize(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/todo_categories_$account.txt");
    _mapCategoryLists[account] = [];
    if (!file.existsSync()) {
      return;
    }
    final categoryRawLines = file.readAsLinesSync();
    for (int i = categoryRawLines.length - 1; i >= 0; i--) {
      if (categoryRawLines[i].trim() == "") {
        categoryRawLines.removeAt(i);
      }
    }
    if (categoryRawLines.isEmpty) {
      return;
    }
    int id = 0;
    for (String categoryRawLine in categoryRawLines) {
      List<String> category = categoryRawLine.split(".");
      String categoryName = category[0];
      Color categoryColor = HexColor.fromHex(category[1]);
      _mapCategoryLists[account]!.add(CategoryModel(
          categoryName: categoryName, color: categoryColor, id: id));
      id++;
    }
  }

  Future<void> writeCategoryListToMemory(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/todo_categories_$account.txt");
    if (!file.existsSync()) {
      file = await file.create();
    }
    var sink = file.openWrite();
    for (CategoryModel categoryModel in _mapCategoryLists[account]!) {
      String categoryLine =
          "${categoryModel.categoryName}.${categoryModel.color.toHex()}";
      sink.writeln(categoryLine);
    }
    sink.close();
  }
}
