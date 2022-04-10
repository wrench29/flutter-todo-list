import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class ValidateAccount extends SignupEvent {
  final String username;
  final String password;
  final String confirmPassword;

  const ValidateAccount({
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [username, password];
}

class SignUpAccount extends SignupEvent {
  final String username;
  final String password;
  final String confirmPassword;

  const SignUpAccount({
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [username, password];
}
