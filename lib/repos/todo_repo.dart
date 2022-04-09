import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:testproject/models/todo_model.dart';

class TodoRepository {
  final Map<String, List<TodoModel>> _mapTodoLists = {};

  List<TodoModel> getTodoModelsList(String account) {
    if (_mapTodoLists[account] == null) {
      return [];
    }
    return [..._mapTodoLists[account]!];
  }

  void addTodoModel(String account, TodoModel todoModel) {
    if (_mapTodoLists[account] == null) {
      return;
    }
    _mapTodoLists[account]!.add(todoModel);
  }

  void removeTodoModel(String account, int index) {
    if (_mapTodoLists[account] == null) {
      return;
    }
    if (index > _mapTodoLists[account]!.length) {
      throw RangeError("Trying to access undefined member of todoList");
    }
    _mapTodoLists[account]!.removeAt(index);
  }

  void sortByCategories(String currentAccount) {
    final todoList = _mapTodoLists[currentAccount]!;

    for (int i = 0; i < todoList.length - 1; i++) {
      for (int j = 0; j < todoList.length - i - 1; j++) {
        if (todoList[j].categoryId < todoList[j + 1].categoryId) {
          TodoModel temp = todoList[j];
          todoList[j] = todoList[j + 1];
          todoList[j + 1] = temp;
        }
      }
    }
  }

  void sortByText(String currentAccount) {
    final todoList = _mapTodoLists[currentAccount]!;
    todoList.sort();
  }

  Future<void> readFromMemoryAndInitialize(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/todos_$account.txt");
    _mapTodoLists[account] = [];
    if (!file.existsSync()) {
      return;
    }
    final todoTexts = await file.readAsString();
    if (todoTexts.isEmpty) {
      return;
    }

    final readJson = jsonDecode(todoTexts);

    for (final todo in readJson) {
      _mapTodoLists[account]!.add(TodoModel.fromJson(todo));
    }
  }

  Future<void> writeTodoListToMemory(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/todos_$account.txt");
    if (!file.existsSync()) {
      file = await file.create();
    }
    var sink = file.openWrite();
    final List<Map<String, dynamic>> todoListToJson = [];
    for (final todoElement in _mapTodoLists[account]!) {
      todoListToJson.add(TodoModel.toJson(todoElement));
    }
    sink.writeln(jsonEncode(todoListToJson));
    sink.close();
  }
}
