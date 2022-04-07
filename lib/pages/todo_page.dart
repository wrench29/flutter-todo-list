import 'package:flutter/material.dart';

import 'package:testproject/todo.dart';

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
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("/categories");
                  },
                  child: const Icon(Icons.more_vert)))
        ],
      ),
      body: const Todo(),
    );
  }
}
