import 'dart:io';
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

  Future<void> readFromMemoryAndInitialize(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/todos_$account.txt");
    _mapTodoLists[account] = [];
    if (!file.existsSync()) {
      return;
    }
    final todoTexts = file.readAsLinesSync();
    for (int i = todoTexts.length - 1; i >= 0; i--) {
      if (todoTexts[i].trim() == "") {
        todoTexts.removeAt(i);
      }
    }
    if (todoTexts.isEmpty) {
      return;
    }
    for (String todo in todoTexts) {
      _mapTodoLists[account]!.add(TodoModel(todoText: todo));
    }
  }

  Future<void> writeTodoListToMemory(String account) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/todos_$account.txt");
    if (!file.existsSync()) {
      file = await file.create();
    }
    var sink = file.openWrite();
    for (TodoModel todoModel in _mapTodoLists[account]!) {
      sink.writeln(todoModel.toString());
    }
    sink.close();
  }
}
