import 'package:flutter/material.dart';

import 'package:testproject/components/custom_padding.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO List App"),
      ),
      body: const InitialForm(),
    );
  }
}

class InitialForm extends StatelessWidget {
  const InitialForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          child: Text("Welcome to my TODO App\nSelect: ",
              style: TextStyle(fontSize: 16)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        ),
        Padding(
          padding: const CustomPadding(),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/signup");
            },
            child: const Text("Sign up a new account"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
          ),
        ),
        Padding(
          padding: const CustomPadding(),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/authentication");
            },
            child: const Text("Log into an existing account"),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
          ),
        )
      ],
    ));
  }
}
