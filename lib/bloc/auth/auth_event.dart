import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class ValidateInput extends AuthEvent {
  final String username;
  final String password;

  const ValidateInput({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class AuthInAccount extends AuthEvent {
  final String username;
  final String password;

  const AuthInAccount({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
