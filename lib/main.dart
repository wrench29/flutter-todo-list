import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/pages/auth_page.dart';
import 'package:testproject/pages/signup_page.dart';
import 'package:testproject/pages/todo_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => TodoBloc(),
      child: const TodoListApp(),
    ),
  );
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
        "/signup": (context) => const SignupPage(),
        "/todo": (context) => const TodoPage(),
      },
      initialRoute: "/signup",
    );
  }
}
