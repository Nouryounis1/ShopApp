import 'package:shop_app/models/login_model.dart';

abstract class RegisterStates {}

class RegisterInitalState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSucessState extends RegisterStates {
  late final LoginModel registerModel;
  RegisterSucessState(this.registerModel);
}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates {}
