import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/bloc/todo/todo_event.dart';

import 'package:testproject/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext contexts) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO List App"),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("/categories");
                    context.read<TodoBloc>().add(const UpdateCategories());
                  },
                  child: const Icon(Icons.more_vert))),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    context.read<TodoBloc>().add(const SortByCategory());
                  },
                  child: const Icon(Icons.sort))),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    context.read<TodoBloc>().add(const SortByText());
                  },
                  child: const Icon(Icons.abc))),
        ],
      ),
      body: const Todo(),
    );
  }
}
