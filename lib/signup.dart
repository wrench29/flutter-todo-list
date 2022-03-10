import 'package:flutter/material.dart';
import 'package:testproject/components/custom_padding.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return const SignupForm();
  }
}

class SignupForm extends StatelessWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          child: Text("Log in your account: ", style: TextStyle(fontSize: 16)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        ),
        Padding(
          padding: const CustomPadding(),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'New username',
            ),
          ),
        ),
        Padding(
          padding: const CustomPadding(),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'New password',
            ),
            obscureText: true,
          ),
        ),
        Padding(
          padding: const CustomPadding(),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'New password confirm',
            ),
            obscureText: true,
          ),
        ),
        Padding(
          padding: const CustomPadding(),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/todo");
            },
            child: const Text("Sign up"),
          ),
        ),
        const Padding(
          child: Text("<Status>", style: TextStyle(fontSize: 16)),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        ),
      ],
    );
  }
}
