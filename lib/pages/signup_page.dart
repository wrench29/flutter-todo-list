import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:testproject/components/custom_padding.dart';
import 'package:testproject/bloc/signup/signup_event.dart';
import 'package:testproject/bloc/signup/signup_bloc.dart';
import 'package:testproject/bloc/signup/signup_state.dart';
import 'package:testproject/models/auth_response_model.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SignupForm(context: context),
    );
  }
}

class SignupForm extends StatelessWidget {
  final BuildContext context;
  final usernameTEController = TextEditingController();
  final passwordTEController = TextEditingController();
  final passwordConfirmTEController = TextEditingController();

  SignupForm({required this.context, Key? key}) : super(key: key) {
    usernameTEController.addListener(_listener);
    passwordTEController.addListener(_listener);
    passwordConfirmTEController.addListener(_listener);
  }

  void _listener() {
    context.read<SignupBloc>().add(ValidateAccount(
        username: usernameTEController.text,
        password: passwordTEController.text,
        confirmPassword: passwordConfirmTEController.text));
  }

  void _onSignUpButtonClicked() {
    context.read<SignupBloc>().add(SignUpAccount(
        username: usernameTEController.text,
        password: passwordTEController.text,
        confirmPassword: passwordConfirmTEController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state.authModel.responseType == AuthResponseType.successSigningUp) {
          Navigator.pushReplacementNamed(context, "/authentication");
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              child: Text(
                "Sign up a new account: ",
                style: TextStyle(fontSize: 16),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            ),
            Padding(
              padding: const CustomPadding(),
              child: TextFormField(
                controller: usernameTEController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'New username',
                ),
              ),
            ),
            Padding(
              padding: const CustomPadding(),
              child: TextFormField(
                controller: passwordTEController,
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
                controller: passwordConfirmTEController,
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
                  if (state.authModel.responseType ==
                      AuthResponseType.successChecking) {
                    _onSignUpButtonClicked();
                  }
                },
                child: const Text("Sign up"),
                style: ButtonStyle(
                  backgroundColor:
                      state.authModel.responseType == AuthResponseType.error
                          ? MaterialStateProperty.all<Color>(Colors.grey)
                          : MaterialStateProperty.all<Color>(Colors.green),
                ),
              ),
            ),
            Padding(
              child: Text(
                state.authModel.errorMessage,
                style: const TextStyle(fontSize: 16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            ),
          ],
        );
      },
    );
  }
}
