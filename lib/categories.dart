import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:testproject/bloc/category/category_event.dart';
import 'package:testproject/bloc/category/category_bloc.dart';
import 'package:testproject/bloc/category/category_state.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Color selectedColor = Colors.white;

  _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "TODO Categories (Account: ${state.username})",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemBuilder: (builder, index) {
            return Card(
              color: state.categoryModelsList[index].color,
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
                    ),
                    IconButton(
                      alignment: Alignment.centerRight,
                      icon: const Icon(Icons.remove),
                      iconSize: 20.0,
                      onPressed: () {
                        removeCategoryPressed(index);
                      },
                    )
                  ],
                ),
              ),
            );
          },
          itemCount: state.categoryModelsList.length,
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
                    labelText: "Add new category",
                    labelStyle: TextStyle(fontSize: 20.0, color: Colors.green),
                    fillColor: Colors.blue,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.color_lens),
                iconSize: 32.0,
                onPressed: () {
                  selectColor();
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                iconSize: 32.0,
                onPressed: () {
                  String text;
                  if ((text = textEditingController.text.trim()) != "") {
                    addCategoryPressed(text, selectedColor);
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
    context.read<CategoryBloc>().add(const FetchCategories());
    super.initState();
  }

  addCategoryPressed(String name, Color color) {
    context
        .read<CategoryBloc>()
        .add(AddCategoryPressed(name: name, color: color));
  }

  removeCategoryPressed(int index) {
    context.read<CategoryBloc>().add(RemoveCategoryPressed(index: index));
  }

  selectColor() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: Colors.white,
                onColorChanged: (color) => {selectedColor = color},
                enableAlpha: false,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Got it'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
