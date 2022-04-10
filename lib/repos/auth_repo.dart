import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AuthRepository {
  final Map<String, String> _userdataMap = {};
  String _currentUsername = "";

  AuthRepository() {
    readFromMemoryAndInitialize();
  }

  void setCurrentUser(String username) {
    if (getPasswordHash(username) == "") {
      throw Exception("Account with this username doesn't exists.");
    }
    _currentUsername = username;
  }

  String getCurrentUser() {
    return _currentUsername;
  }

  Future<void> addAccount(String username, String passwordHash) async {
    _userdataMap[username] = passwordHash;
    await writeAccountsListToMemory();
  }

  Future<void> removeAccount(String username) async {
    _userdataMap.remove(username);
    await writeAccountsListToMemory();
  }

  String getPasswordHash(String username) {
    if (_userdataMap.containsKey(username)) {
      return _userdataMap[username]!;
    }
    return "";
  }

  Future<void> readFromMemoryAndInitialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/accounts.txt");
    if (!file.existsSync()) {
      return;
    }
    final accountsLines = file.readAsLinesSync();
    for (int i = accountsLines.length - 1; i >= 0; i--) {
      if (accountsLines[i].trim() == "") {
        accountsLines.removeAt(i);
        continue;
      }
      final List<String> pair = accountsLines[i].split(" ");
      if (pair.length != 2) {
        throw AssertionError("Username and password pair was corrupted.");
      }
      _userdataMap[pair[0]] = pair[1];
    }
  }

  Future<void> writeAccountsListToMemory() async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/accounts.txt");
    if (!file.existsSync()) {
      file = await file.create();
    }
    final sink = file.openWrite();
    for (var item in _userdataMap.entries) {
      sink.writeln(item.key + " " + item.value);
    }
    sink.close();
  }
}
