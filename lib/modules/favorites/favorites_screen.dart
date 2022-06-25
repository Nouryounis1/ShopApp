import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/favoriesGet_model.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return BuildCondition(
          condition: state is! ShopLoadingGetFavoritesState,
          builder: (context) => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Your Favorites",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 22.0),
                          ),
                          Text(
                            "${ShopCubit.get(context).favoritesModel!.data!.data!.length} items",
                            style: !CacheHelper.getData(key: 'isDark')
                                ? Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.black)
                                : Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildCartItem(
                        ShopCubit.get(context)
                            .favoritesModel!
                            .data!
                            .data![index]
                            .product,
                        context),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: ShopCubit.get(context)
                        .favoritesModel!
                        .data!
                        .data!
                        .length,
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildCartItem(Product? model, context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              ShopCubit.get(context).changeFavorites(model!.id!);
            },
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFE6E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Spacer(),
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 98,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(
                      '${model!.image}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                            text: '${model.name}',
                            style: !CacheHelper.getData(key: 'isDark')
                                ? TextStyle(color: Colors.black)
                                : TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "\$${model.price}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: defaultColor),
                          children: [],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
