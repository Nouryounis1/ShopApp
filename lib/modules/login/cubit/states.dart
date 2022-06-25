import 'package:shop_app/models/login_model.dart';

abstract class LoginStates {}

class LoginInitalState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSucessState extends LoginStates {
  late final LoginModel loginModel;
  LoginSucessState(this.loginModel);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}

class LoginChangePasswordVisibilityState extends LoginStates {}
