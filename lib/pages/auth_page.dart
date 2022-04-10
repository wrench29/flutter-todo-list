import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testproject/components/custom_padding.dart';
import 'package:testproject/bloc/auth/auth_event.dart';
import 'package:testproject/bloc/auth/auth_bloc.dart';
import 'package:testproject/bloc/auth/auth_state.dart';
import 'package:testproject/models/auth_response_model.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in"),
      ),
      body: AuthenticationForm(context: context),
    );
  }
}

class AuthenticationForm extends StatelessWidget {
  final BuildContext context;
  final TextEditingController usernameTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();

  AuthenticationForm({Key? key, required this.context}) : super(key: key) {
    usernameTEController.addListener(_listener);
    passwordTEController.addListener(_listener);
  }

  void _listener() {
    String username = usernameTEController.text;
    String password = passwordTEController.text;
    context.read<AuthBloc>().add(ValidateInput(
          username: username,
          password: password,
        ));
  }

  void _onLogInButtonClicked() {
    String username = usernameTEController.text;
    String password = passwordTEController.text;
    context.read<AuthBloc>().add(AuthInAccount(
          username: username,
          password: password,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.authModel.responseType == AuthResponseType.successAuth) {
        Navigator.of(context).pushReplacementNamed("/todo");
      }
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            child:
                Text("Log in your account: ", style: TextStyle(fontSize: 16)),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
          Padding(
            padding: const CustomPadding(),
            child: TextFormField(
              controller: usernameTEController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Your username',
              ),
            ),
          ),
          Padding(
            padding: const CustomPadding(),
            child: TextFormField(
              controller: passwordTEController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
          ),
          Padding(
            padding: const CustomPadding(),
            child: ElevatedButton(
              onPressed: () {
                _onLogInButtonClicked();
              },
              child: const Text("Log in"),
              style: ButtonStyle(
                  backgroundColor:
                      state.authModel.responseType == AuthResponseType.error
                          ? MaterialStateProperty.all<Color>(Colors.grey)
                          : MaterialStateProperty.all<Color>(Colors.green)),
            ),
          ),
          Padding(
            child: Text(state.authModel.errorMessage,
                style: const TextStyle(fontSize: 16)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          ),
        ],
      );
    });
  }
}
