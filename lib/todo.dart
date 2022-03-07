import 'package:flutter/material.dart';
import 'package:testproject/bloc/todo_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Debug
import 'package:flutter/foundation.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_state.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TextEditingController teController = TextEditingController();
  final ScrollController scrlController = ScrollController();

  _scrollDown() {
    scrlController.animateTo(
      scrlController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Text(
            "TODO List:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
      Expanded(
          child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) => ListView.builder(
                  controller: scrlController,
                  shrinkWrap: true,
                  itemBuilder: (builder, index) {
                    return Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(
                                        "${index + 1}) ${state.todoModel.todoTexts[index]}",
                                        style: const TextStyle(fontSize: 16))),
                                IconButton(
                                  alignment: Alignment.centerRight,
                                  icon: const Icon(Icons.remove),
                                  iconSize: 20.0,
                                  onPressed: () {
                                    removeTodoPressed(index);
                                  },
                                )
                              ],
                            )));
                  },
                  itemCount: state.todoModel.todoTexts.length))),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
              child: TextFormField(
                controller: teController,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Add new task",
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.green),
                  fillColor: Colors.blue,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent)),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 32.0,
              onPressed: () {
                String text;
                if ((text = teController.text.trim()) != "") {
                  addTodoPressed(text);
                  teController.text = "";
                  Future.delayed(const Duration(milliseconds: 10), _scrollDown);
                }
              },
            )
          ])),
    ]);
  }

  addTodoPressed(String text) {
    context.read<TodoBloc>().add(AddTodoPressed(text: text));
  }

  removeTodoPressed(int index) {
    context.read<TodoBloc>().add(RemoveTodoPressed(index: index));
  }
}
