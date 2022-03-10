import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/pages/pages.dart';
import 'package:testproject/repos/todo_repo.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TodoBloc(context.read<TodoRepository>()),
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
        "/authentication": (context) => const AuthenticationPage(),
        "/signup": (context) => const SignupPage(),
        "/todo": (context) => const TodoPage(),
      },
      initialRoute: "/signup",
    );
  }
}
