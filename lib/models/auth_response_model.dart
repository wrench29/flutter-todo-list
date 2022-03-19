import 'package:equatable/equatable.dart';

enum AuthResponseType { error, successChecking, successSigningUp, successAuth }

class AuthResponseModel extends Equatable {
  const AuthResponseModel(
      {this.responseType = AuthResponseType.error, this.errorMessage = ""});

  final String errorMessage;
  final AuthResponseType responseType;

  @override
  List<Object> get props => [responseType, errorMessage];
}
