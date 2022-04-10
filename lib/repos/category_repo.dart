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
    final list = _mapCategoryLists[account]!;
    if (list.isNotEmpty) {
      newId = list[_mapCategoryLists[account]!.length - 1].id + 1;
    }
    list.add(CategoryModel(categoryName: name, color: color, id: newId));
  }

  void removeCategoryModel(String account, int index) {
    var listOrNull = _mapCategoryLists[account];
    if (listOrNull == null) {
      return;
    }
    if (index > listOrNull.length) {
      throw RangeError("Trying to access undefined member of categoryList");
    }
    listOrNull.removeAt(index);
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
    for (final categoryRawLine in categoryRawLines) {
      List<String> category = categoryRawLine.split(".");
      _mapCategoryLists[account]!.add(CategoryModel(
        categoryName: category[0],
        color: HexColor.fromHex(category[1]),
        id: id,
      ));
      id++;
    }
  }

  Future<void> writeCategoryListToMemory(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/todo_categories_$account.txt");
    if (!file.existsSync()) {
      file = await file.create();
    }
    final sink = file.openWrite();
    for (CategoryModel categoryModel in _mapCategoryLists[account]!) {
      sink.writeln(
        "${categoryModel.categoryName}.${categoryModel.color.toHex()}",
      );
    }
    sink.close();
  }
}
