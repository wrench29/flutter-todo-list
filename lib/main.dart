import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/signup/signup_bloc.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/initial.dart';
import 'package:testproject/pages/initial_page.dart';
import 'package:testproject/pages/pages.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/repos/todo_repo.dart';

import 'bloc/auth/auth_bloc.dart';

void main() {
  runApp(const AppProvider(child: TodoListApp()));
}

class AppProvider extends StatelessWidget {
  final Widget child;

  const AppProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => TodoRepository()),
        RepositoryProvider(create: (_) => AuthRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TodoBloc(
                context.read<TodoRepository>(), context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => SignupBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }
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
        "/initial": (context) => const InitialPage(),
        "/authentication": (context) => const AuthenticationPage(),
        "/signup": (context) => const SignupPage(),
        "/todo": (context) => const TodoPage(),
      },
      initialRoute: "/initial",
    );
  }
}
