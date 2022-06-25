import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/states.dart';
import 'package:shop_app/network/endpoints/end_points.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitalState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  LoginModel? registerModel;

  void userRegister(
      {required String? name,
      required String? email,
      required String pasword,
      required String? phone}) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTEr,
      data: {'name': name, 'email': email, 'password': pasword, 'phone': phone},
    ).then((value) {
      registerModel = LoginModel.fromJson(value.data);

      emit(RegisterSucessState(registerModel!));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void ChangePasswordVisbility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }
}
