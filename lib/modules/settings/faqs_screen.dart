import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/styles/colors.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).faqsModel;
        return Scaffold(
          appBar: AppBar(
            title: Text('FAQs'),
          ),
          body: BuildCondition(
              condition: ShopCubit.get(context).faqsModel != null,
              fallback: (context) => Center(child: CircularProgressIndicator()),
              builder: (context) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => ExpansionPanelList(
                              animationDuration: Duration(milliseconds: 1000),
                              dividerColor: Colors.red,
                              elevation: 1,
                              children: [
                                ExpansionPanel(
                                  body: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '${model!.data!.data![index].answer}',
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 15,
                                              letterSpacing: 0.3,
                                              height: 1.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        '${model.data!.data![index].question}',
                                        style: TextStyle(
                                          color: defaultColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    );
                                  },
                                  isExpanded: ShopCubit.get(context).isExpanded,
                                )
                              ],
                              expansionCallback: (int item, bool status) {
                                ShopCubit.get(context).changePanel();
                              },
                            ),
                        separatorBuilder: (context, index) => myDivider(),
                        itemCount: model!.data!.data!.length),
                  )),
        );
      },
    );
  }
}
