import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';

class AccountSettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).profileModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;

        return BuildCondition(
            condition: ShopCubit.get(context).profileModel != null,
            fallback: (context) => Center(child: CircularProgressIndicator()),
            builder: (context) => Material(
                  child: Scaffold(
                    appBar: AppBar(),
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                if (state is ShopLoadingUpdateProfileState)
                                  LinearProgressIndicator(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: nameController,
                                  type: TextInputType.name,
                                  validateText: 'name must not be empty',
                                  label: 'Name',
                                  prefix: Icons.person,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  validateText: 'email must not be empty',
                                  label: 'Email Address',
                                  prefix: Icons.email,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: phoneController,
                                  type: TextInputType.phone,
                                  validateText: 'phone must not be empty',
                                  label: 'Phone',
                                  prefix: Icons.phone,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      ShopCubit.get(context).updatePorfile(
                                          nameController.text,
                                          emailController.text,
                                          phoneController.text);
                                    }
                                  },
                                  text: 'update',
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
      },
    );
  }
}
