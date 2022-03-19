import 'package:equatable/equatable.dart';

import 'package:testproject/models/auth_response_model.dart';

abstract class AuthState extends Equatable {
  final AuthResponseModel authModel;

  const AuthState({required this.authModel});

  @override
  List<Object> get props => [authModel];
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(authModel: const AuthResponseModel());
}

class AuthChanged extends AuthState {
  const AuthChanged(AuthResponseModel authModel) : super(authModel: authModel);

  @override
  List<Object> get props => [authModel];
}
