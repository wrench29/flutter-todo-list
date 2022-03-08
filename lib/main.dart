import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';

import 'authentication.dart';
import 'todo.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => TodoBloc(),
    child: const TodoListApp(),
  ));
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        "/authentication": (context) => const AuthenticationPage(),
        "/todo": (context) => const TodoPage(),
      },
      initialRoute: "/authentication",
    );
  }
}

////
// Todo Classes
////
class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TODO List App"),
        ),
        body: const Todo());
  }
}

////
// Authentication Classes
////
class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TODO List App"),
        ),
        body: const Authentication());
  }
}
