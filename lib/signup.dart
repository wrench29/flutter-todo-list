import 'package:flutter/material.dart';
import 'package:testproject/components/custom_padding.dart';
import 'package:testproject/bloc/signup/signup_event.dart';
import 'package:testproject/bloc/signup/signup_bloc.dart';
import 'package:testproject/bloc/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testproject/models/auth_response_model.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return SignupForm(
      context: context,
    );
  }
}

class SignupForm extends StatelessWidget {
  final BuildContext context;
  final TextEditingController usernameTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController passwordConfirmTEController =
      TextEditingController();

  SignupForm({required this.context, Key? key}) : super(key: key) {
    usernameTEController.addListener(_listener);
    passwordTEController.addListener(_listener);
    passwordConfirmTEController.addListener(_listener);
  }

  void _listener() {
    String username = usernameTEController.text;
    String password = passwordTEController.text;
    String passwordConfirm = passwordConfirmTEController.text;
    context.read<SignupBloc>().add(ValidateAccount(
        username: username,
        password: password,
        confirmPassword: passwordConfirm));
  }

  void _onSignUpButtonClicked() {
    String username = usernameTEController.text;
    String password = passwordTEController.text;
    String passwordConfirm = passwordConfirmTEController.text;
    context.read<SignupBloc>().add(SignUpAccount(
        username: username,
        password: password,
        confirmPassword: passwordConfirm));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Padding(
            child:
                Text("Sign up a new account: ", style: TextStyle(fontSize: 16)),
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
                  Navigator.of(context).pushReplacementNamed("/authentication");
                }
              },
              child: const Text("Sign up"),
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
