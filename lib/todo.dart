import 'package:flutter/material.dart';
import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/bloc/todo/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/repos/auth_repo.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
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
        ),
      ),
      Expanded(
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            return ListView.builder(
              controller: scrollController,
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
                            "${index + 1}) ${state.todoModelsList[index]}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          alignment: Alignment.centerRight,
                          icon: const Icon(Icons.remove),
                          iconSize: 20.0,
                          onPressed: () {
                            removeTodoPressed(index);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: state.todoModelsList.length,
            );
          },
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Add new task",
                  labelStyle: TextStyle(fontSize: 20.0, color: Colors.green),
                  fillColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 32.0,
              onPressed: () {
                String text;
                if ((text = textEditingController.text.trim()) != "") {
                  addTodoPressed(text);
                  textEditingController.text = "";
                  Future.delayed(const Duration(milliseconds: 10), _scrollDown);
                }
              },
            ),
          ],
        ),
      ),
    ]);
  }

  @override
  void initState() {
    context.read<TodoBloc>().add(
        FetchTodos(account: context.read<AuthRepository>().getCurrentUser()));
    super.initState();
  }

  addTodoPressed(String text) {
    context.read<TodoBloc>().add(AddTodoPressed(
        account: context.read<AuthRepository>().getCurrentUser(), text: text));
  }

  removeTodoPressed(int index) {
    context.read<TodoBloc>().add(RemoveTodoPressed(
        account: context.read<AuthRepository>().getCurrentUser(),
        index: index));
  }
}
