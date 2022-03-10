import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<String> readContent() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File("${directory.path}/todos.txt");
  if (!await file.exists()) {
    return "";
  }
  return await file.readAsString();
}

Future<void> writeContent(String content) async {
  final directory = await getApplicationDocumentsDirectory();
  var file = File("${directory.path}/todos.txt");
  if (!await file.exists()) {
    file = await file.create();
  }
  var sink = file.openWrite();
  sink.write(content);
  sink.close();
}
