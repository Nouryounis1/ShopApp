import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/register/cubit.dart';
import 'package:shop_app/modules/register/states.dart';
import 'package:shop_app/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
            listener: (context, states) {
          if (states is RegisterSucessState) {
            if (states.registerModel.status) {
              print(states.registerModel.data?.token);
              print(states.registerModel.message);

              CacheHelper.saveData(
                      key: 'token', value: states.registerModel.data?.token)
                  .then((value) {
                token = states.registerModel.data!.token!;

                navigateAndFinish(context, ShopLayout());
              });
            } else {
              print(states.registerModel.message);
              showToast(
                  text: states.registerModel.message, state: ToastStates.ERROR);
            }
          }
        }, builder: (context, state) {
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
                        Text('REGISTER',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.black)),
                        Text('Register now to browse our hot offers',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey)),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            label: 'Username',
                            prefix: Icons.person_outline,
                            validateText: 'Please enter your nmae'),
                        SizedBox(
                          height: 15.0,
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
                            suffix: RegisterCubit.get(context).suffix,
                            isPassword: RegisterCubit.get(context).isPassword,
                            sufixPressed: () {
                              RegisterCubit.get(context)
                                  .ChangePasswordVisbility();
                            },
                            validateText: 'password is too short'),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            label: 'Phone',
                            prefix: Icons.phone,
                            validateText: 'please enter your phone'),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildCondition(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                              onPressed: () {
                                if (formKey.currentState == null) {
                                  print('null key');
                                } else if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      email: emailController.text,
                                      pasword: passwordController.text,
                                      phone: phoneController.text);
                                }
                              },
                              text: 'register'),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Alerady have an account?'),
                            defaultTextButton(
                                onPressed: () {
                                  navigateTo(context, LoginScreen());
                                },
                                text: 'login'.toUpperCase())
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
        }));
  }
}
