import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/modules/address/addaddress_screen.dart';
import 'package:shop_app/modules/address/update_address_screen.dart';
import 'package:shop_app/styles/colors.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = ShopCubit.get(context).addressModel;
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Material(
            child: Scaffold(
              appBar: AppBar(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: FloatingActionButton(
                  onPressed: () {
                    navigateTo(context, AddNewAddress());
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(Duration(seconds: 1), () {
                    ShopCubit.get(context).refreshAddress;
                  });
                },
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${model!.data!.data![index].name}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                          Spacer(),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    // return object of type Dialog
                                                    return AlertDialog(
                                                      title: new Text(
                                                          "Alert Dialog title"),
                                                      content: new Text(
                                                          "Alert Dialog body"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new FlatButton(
                                                          child:
                                                              new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),

                                                        new FlatButton(
                                                          child: new Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          onPressed: () {
                                                            ShopCubit.get(
                                                                    context)
                                                                .deleteAddress(
                                                                    model
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .id);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                navigateTo(
                                                    context,
                                                    UpdateAddress(
                                                      model.data!.data![index]
                                                          .name,
                                                      model.data!.data![index]
                                                          .city,
                                                      model.data!.data![index]
                                                          .region,
                                                      model.data!.data![index]
                                                          .details,
                                                      model.data!.data![index]
                                                          .notes,
                                                      model.data!.data![index]
                                                          .id,
                                                    ));
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: defaultColor,
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'City: ${model.data!.data![index].city}',
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                          'Region: ${model.data!.data![index].region}'),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                          'Details: ${model.data!.data![index].details}'),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                            separatorBuilder: (context, index) => myDivider(),
                            itemCount: model!.data!.data!.length),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
