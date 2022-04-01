import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:testproject/bloc/auth/auth_event.dart';
import 'package:testproject/models/auth_response_model.dart';
import 'package:testproject/repos/auth_repo.dart';
import 'package:testproject/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(const AuthInitial()) {
    on<ValidateInput>(_onValidateInput);
    on<AuthInAccount>(_onAuthInAccount);
  }

  void _onValidateInput(
    ValidateInput event,
    Emitter<AuthState> emitter,
  ) {
    if (event.username.trim() == "") {
      emitter(const AuthChanged(AuthResponseModel(
          responseType: AuthResponseType.error,
          errorMessage: "Username cannot be empty.")));
      return;
    }
    if (event.password == "") {
      emitter(const AuthChanged(AuthResponseModel(
          responseType: AuthResponseType.error,
          errorMessage: "Password cannot be empty.")));
      return;
    }
    emitter(const AuthChanged(
        AuthResponseModel(responseType: AuthResponseType.successChecking)));
  }

  Future<void> _onAuthInAccount(
    AuthInAccount event,
    Emitter<AuthState> emitter,
  ) async {
    String passwordHash = authRepository.getPasswordHash(event.username);
    if (passwordHash != "" && DBCrypt().checkpw(event.password, passwordHash)) {
      authRepository.setCurrentUser(event.username);
      emitter(const AuthChanged(
          AuthResponseModel(responseType: AuthResponseType.successAuth)));
      return;
    }
    emitter(const AuthChanged(AuthResponseModel(
        responseType: AuthResponseType.error,
        errorMessage: "Wrong username or/and password.")));
  }
}
