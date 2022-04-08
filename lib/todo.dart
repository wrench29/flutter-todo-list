import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/bloc/category/category_bloc.dart';
import 'package:testproject/bloc/category/category_event.dart';

import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/bloc/todo/todo_state.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/repos/category_repo.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  int selectedCategoryId = -1;

  _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      return Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "TODO List (Account: ${state.username})",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (builder, index) {
            return Card(
              color: state
                  .getCategoryById(state.todoModelsList[index].categoryId)
                  .color,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${index + 1}) ${state.todoModelsList[index].todoText}",
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
        )),
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
                icon: const Icon(Icons.category),
                iconSize: 32.0,
                onPressed: () {
                  selectCategory(state);
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                iconSize: 32.0,
                onPressed: () {
                  String text;
                  if ((text = textEditingController.text.trim()) != "" &&
                      selectedCategoryId > -1) {
                    addTodoPressed(text, selectedCategoryId);
                    textEditingController.text = "";
                    Future.delayed(
                        const Duration(milliseconds: 10), _scrollDown);
                  }
                },
              ),
            ],
          ),
        ),
      ]);
    });
  }

  @override
  void initState() {
    context.read<TodoBloc>().add(const FetchTodos());
    super.initState();
  }

  addTodoPressed(String text, int categoryId) {
    context
        .read<TodoBloc>()
        .add(AddTodoPressed(text: text, categoryId: categoryId));
  }

  removeTodoPressed(int index) {
    context.read<TodoBloc>().add(RemoveTodoPressed(index: index));
  }

  selectCategory(TodoState state) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select a category:'),
            content: Container(
                height: 400,
                width: 200,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        "Categories: ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemBuilder: (builder, index) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: state.categoryModelsList[index].color),
                          onPressed: () => {
                            selectedCategoryId =
                                state.categoryModelsList[index].id,
                            Navigator.of(context).pop()
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    state
                                        .categoryModelsList[index].categoryName,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                        // GestureDetector(
                        //   onTap: () => {
                        //     // TODO: Fix that motherfucking piece of fuck
                        //     selectedCategoryId =
                        //         state.categoryModelsList[index].id
                        //   },
                        //   child: Card(
                        //     color: state.categoryModelsList[index].color,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.start,
                        //         children: [
                        //           Expanded(
                        //             child: Text(
                        //               state.categoryModelsList[index]
                        //                   .categoryName,
                        //               style: const TextStyle(fontSize: 16),
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                      },
                      itemCount: state.categoryModelsList.length,
                    ),
                  ],
                ))),
          );
        });
  }
}
