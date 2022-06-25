import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(listener: (context, states) {
        if (states is LoginSucessState) {
          if (states.loginModel.status) {
            print(states.loginModel.data?.token);
            print(states.loginModel.message);

            CacheHelper.saveData(
                    key: 'token', value: states.loginModel.data?.token)
                .then((value) {
              token = states.loginModel.data!.token!;
              navigateAndFinish(context, ShopLayout());
            });
          } else {
            print(states.loginModel.message);
            showToast(
                text: states.loginModel.message, state: ToastStates.ERROR);
          }
        }
      }, builder: (context, states) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black)),
                      Text('Login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey)),
                      SizedBox(
                        height: 30.0,
                      ),
                      defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          label: 'Email address',
                          prefix: Icons.email_outlined,
                          validateText: 'Please enter your email address'),
                      SizedBox(
                        height: 15.0,
                      ),
                      defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: LoginCubit.get(context).suffix,
                          isPassword: LoginCubit.get(context).isPassword,
                          sufixPressed: () {
                            LoginCubit.get(context).ChangePasswordVisbility();
                          },
                          validateText: 'password is too short'),
                      SizedBox(
                        height: 15.0,
                      ),
                      BuildCondition(
                        condition: states is! LoginLoadingState,
                        builder: (context) => defaultButton(
                            onPressed: () {
                              if (formKey.currentState == null) {
                                print('null key');
                              } else if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    pasword: passwordController.text);
                              }
                            },
                            text: 'login'),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          defaultTextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'register'.toUpperCase())
                          //  TextButton(onPressed: () {}, child: Text('register'))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
