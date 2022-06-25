import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/network/endpoints/end_points.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitalState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  late LoginModel loginModel;

  void userLogin({required String? email, required String pasword}) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {'email': email, 'password': pasword},
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);

      emit(LoginSucessState(loginModel));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  void ChangePasswordVisbility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginChangePasswordVisibilityState());
  }
}
