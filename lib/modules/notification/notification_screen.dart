import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/styles/colors.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = ShopCubit.get(context).notifiactionModel;
          return Scaffold(
            appBar: AppBar(
              title: Text('Notifications'),
            ),
            body: ListView.separated(
                itemBuilder: (context, index) => EasyCard(
                    defaultColor,
                    '${model!.data!.data![index].title}',
                    '${model.data!.data![index].message}',
                    Colors.white,
                    Colors.grey,
                    Colors.black),
                separatorBuilder: (context, index) => Container(),
                itemCount: model!.data!.data!.length),
          );
        });
  }
}
