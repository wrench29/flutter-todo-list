import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:testproject/models/todo_model.dart';

class TodoRepository {
  final List<TodoModel> _todoList = [];

  List<TodoModel> getTodoModelsList() {
    return [..._todoList];
  }

  void addTodoModel(TodoModel todoModel) {
    _todoList.add(todoModel);
  }

  void removeTodoModel(int index) {
    assert(index < _todoList.length,
        "Trying to access undefined member of _todoList");
    _todoList.removeAt(index);
  }

  Future<void> readFromMemoryAndInitialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/todos.txt");
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
      _todoList.add(TodoModel(todoText: todo));
    }
  }

  Future<void> writeTodoListToMemory() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/todos.txt");
    if (!file.existsSync()) {
      file = await file.create();
    }
    var sink = file.openWrite();
    for (TodoModel todoModel in _todoList) {
      sink.writeln(todoModel.toString());
    }
    sink.close();
  }
}
