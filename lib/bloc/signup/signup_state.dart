import 'package:equatable/equatable.dart';

import 'package:testproject/models/auth_response_model.dart';

abstract class SignupState extends Equatable {
  final AuthResponseModel authModel;

  const SignupState({required this.authModel});

  @override
  List<Object> get props => [authModel];
}

class SignupInitial extends SignupState {
  const SignupInitial() : super(authModel: const AuthResponseModel());
}

class SignupChanged extends SignupState {
  const SignupChanged(
    AuthResponseModel authModel,
  ) : super(authModel: authModel);

  @override
  List<Object> get props => [authModel];
}
