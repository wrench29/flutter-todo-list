import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:testproject/bloc/signup/signup_event.dart';
import 'package:testproject/bloc/signup/signup_state.dart';
import 'package:testproject/models/auth_response_model.dart';
import 'package:testproject/repos/auth_repo.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  AuthRepository authRepository;

  SignupBloc(this.authRepository) : super(const SignupInitial()) {
    on<ValidateAccount>(_onValidateAccount);
    on<SignUpAccount>(_onSignUpAccount);
  }

  void _onValidateAccount(
    ValidateAccount event,
    Emitter<SignupState> emitter,
  ) {
    emitter(SignupChanged(
      _checkUserData(event.username, event.password, event.confirmPassword),
    ));
  }

  Future<void> _onSignUpAccount(
    SignUpAccount event,
    Emitter<SignupState> emitter,
  ) async {
    AuthResponseModel responseModel = _checkUserData(
      event.username,
      event.password,
      event.confirmPassword,
    );
    if (responseModel.responseType == AuthResponseType.successChecking) {
      await authRepository.addAccount(
        event.username,
        DBCrypt().hashpw(event.password, DBCrypt().gensalt()),
      );
      responseModel = const AuthResponseModel(
        responseType: AuthResponseType.successSigningUp,
      );
    }
    emitter(SignupChanged(responseModel));
  }

  AuthResponseModel _checkUserData(
    String username,
    String password,
    String confirmPassword,
  ) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    if (username.length < 3 || username.length > 16) {
      return const AuthResponseModel(
        responseType: AuthResponseType.error,
        errorMessage: "Username length must be between 3 and 16 characters.",
      );
    }
    if (password.length < 5 || password.length > 16) {
      return const AuthResponseModel(
        responseType: AuthResponseType.error,
        errorMessage: "Password length must be between 5 and 16 characters.",
      );
    }
    if (!alphanumeric.hasMatch(username) || !alphanumeric.hasMatch(password)) {
      return const AuthResponseModel(
        responseType: AuthResponseType.error,
        errorMessage: "You can use only numbers,"
            "capital and/or lowercase latin characters.",
      );
    }
    if (password != confirmPassword) {
      return const AuthResponseModel(
        responseType: AuthResponseType.error,
        errorMessage: "Passwords are not equal.",
      );
    }
    String passwordHash = authRepository.getPasswordHash(username);
    if (passwordHash != "") {
      return const AuthResponseModel(
        responseType: AuthResponseType.error,
        errorMessage: "Account with this username already exists.",
      );
    }
    return const AuthResponseModel(
      responseType: AuthResponseType.successChecking,
    );
  }
}
