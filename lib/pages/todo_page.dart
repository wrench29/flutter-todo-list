import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:testproject/bloc/todo/todo_event.dart';
import 'package:testproject/bloc/todo/todo_bloc.dart';
import 'package:testproject/bloc/todo/todo_state.dart';

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
              child: const Icon(Icons.more_vert),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                context.read<TodoBloc>().add(const SortByCategory());
              },
              child: const Icon(Icons.sort),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                context.read<TodoBloc>().add(const SortByText());
              },
              child: const Icon(Icons.abc),
            ),
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "TODO List (Account: ${state.username})",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: searchTEController,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Search...",
                  labelStyle: TextStyle(fontSize: 12.0, color: Colors.green),
                  fillColor: Colors.blue,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purpleAccent),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemBuilder: (builder, index) {
                    return Card(
                      color: state
                          .getCategoryById(
                              state.todoModelsList[index].categoryId)
                          .color,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            state
                                .categoryModelsList[
                                    state.todoModelsList[index].categoryId]
                                .categoryName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  state.todoModelsList[index].todoText,
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
                        ]),
                      ),
                    );
                  },
                  itemCount: state.todoModelsList.length,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: taskTEController,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: "Add new task",
                          labelStyle: TextStyle(
                            fontSize: 20.0,
                            color: Colors.green,
                          ),
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
                        final text = taskTEController.text.trim();
                        if (text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Todo text cannot be empty.",
                          );
                          return;
                        }
                        if (selectedCategoryId == -1) {
                          Fluttertoast.showToast(
                            msg: "You must select the category.",
                          );
                          return;
                        }
                        addTodoPressed(text, selectedCategoryId);
                        taskTEController.text = "";
                        Future.delayed(
                          const Duration(milliseconds: 10),
                          _scrollDown,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  final taskTEController = TextEditingController();
  final searchTEController = TextEditingController();
  final scrollController = ScrollController();
  int selectedCategoryId = -1;

  _TodoPageState() {
    searchTEController.addListener(() {
      String searchText = searchTEController.text.trim();
      context.read<TodoBloc>().add(SetSearchFilter(searchText: searchText));
    });
  }

  _resetSearch() {
    searchTEController.clear();
    context.read<TodoBloc>().add(const SetSearchFilter(searchText: ""));
  }

  _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    context.read<TodoBloc>().add(const FetchTodos());
    super.initState();
  }

  addTodoPressed(String text, int categoryId) {
    _resetSearch();
    context
        .read<TodoBloc>()
        .add(AddTodoPressed(text: text, categoryId: categoryId));
  }

  removeTodoPressed(int index) {
    _resetSearch();
    context.read<TodoBloc>().add(RemoveTodoPressed(index: index));
  }

  selectCategory(TodoState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a category:'),
          content: SizedBox(
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemBuilder: (builder, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: state.categoryModelsList[index].color,
                        ),
                        onPressed: () {
                          selectedCategoryId =
                              state.categoryModelsList[index].id;
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  state.categoryModelsList[index].categoryName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.categoryModelsList.length,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
