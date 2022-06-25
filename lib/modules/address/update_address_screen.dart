import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';

class UpdateAddress extends StatelessWidget {
  final String? name;
  final String? city;
  final String? region;
  final String? details;
  final String? notes;
  final int? id;

  UpdateAddress(
      this.name, this.city, this.region, this.details, this.notes, this.id);
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var cityController = TextEditingController();
  var regionController = TextEditingController();
  var detailsController = TextEditingController();
  var notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BuildCondition(
            condition: ShopCubit.get(context).addressModel != null,
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
                                if (state is ShopLoadingUpdateAddressDataState)
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
                                  controller: cityController,
                                  type: TextInputType.text,
                                  validateText: 'city must not be empty',
                                  label: 'City',
                                  prefix: Icons.location_city,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: regionController,
                                  type: TextInputType.text,
                                  validateText: 'region must not be empty',
                                  label: 'Region',
                                  prefix: Icons.maps_home_work,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: detailsController,
                                  type: TextInputType.text,
                                  validateText: 'details must not be empty',
                                  label: 'Details',
                                  prefix: Icons.topic,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultFormField(
                                  controller: notesController,
                                  type: TextInputType.text,
                                  validateText: 'notes must not be empty',
                                  label: 'Notes',
                                  prefix: Icons.notes,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultButton(
                                    onPressed: () {
                                      ShopCubit.get(context)
                                          .getCurrentLocation();
                                    },
                                    text: 'Add Current Location'),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultButton(
                                  onPressed: () {
                                    if (formKey.currentState == null) {
                                      print('null key');
                                    } else if (formKey.currentState!
                                        .validate()) {
                                      ShopCubit.get(context).updateAddress(
                                        nameController.text,
                                        cityController.text,
                                        regionController.text,
                                        detailsController.text,
                                        notesController.text,
                                        ShopCubit.get(context)
                                            .latitude
                                            .toString(),
                                        ShopCubit.get(context)
                                            .longitude
                                            .toString(),
                                        id!,
                                      );
                                      print(id);
                                    }
                                  },
                                  text: 'Update',
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
