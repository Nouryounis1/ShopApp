import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit.dart';
import 'package:shop_app/modules/search/states.dart';
import 'package:shop_app/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SearchCubit(),
        child: BlocConsumer<SearchCubit, SearchState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(),
                body: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        defaultFormField(
                            controller: searchController,
                            type: TextInputType.text,
                            label: 'Search',
                            prefix: Icons.search,
                            onSubmmit: (String text) {
                              SearchCubit.get(context).search(text);
                            },
                            validateText: 'text must not be empty'),
                        SizedBox(
                          height: 10.0,
                        ),
                        if (state is SearchLoadingState)
                          LinearProgressIndicator(),
                        if (state is SearchSuccessState)
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) => buildListProduct(
                                  SearchCubit.get(context)
                                      .searchModel!
                                      .data!
                                      .data![index],
                                  context,
                                  isOldPrice: false),
                              separatorBuilder: (context, index) => myDivider(),
                              itemCount: SearchCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data!
                                  .length,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Widget buildListProduct(
    Product model,
    context, {
    bool isOldPrice = true,
  }) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 120.0,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage('${model.image}'),
                    width: 120.0,
                    height: 120.0,
                  ),
                  if (model.discount != 0 && isOldPrice)
                    Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: Text(
                        'DISCOUNT',
                        style: TextStyle(
                          fontSize: 8.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 1.3,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          model.price.toString(),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (model.discount != 0 && isOldPrice)
                          Text(
                            model.oldPrice.toString(),
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            ShopCubit.get(context).changeFavorites(model.id!);
                          },
                          icon: CircleAvatar(
                            radius: 15.0,
                            backgroundColor:
                                ShopCubit.get(context).favorites![model.id]!
                                    ? defaultColor
                                    : Colors.grey,
                            child: Icon(
                              Icons.favorite_border,
                              size: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
