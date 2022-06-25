import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/categories_products_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories_products/cubit.dart';
import 'package:shop_app/modules/categories_products/states.dart';
import 'package:shop_app/modules/product_detials/products_details_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

class CategoryProductsScreen extends StatelessWidget {
  final int catId;
  final String? name;

  CategoryProductsScreen(this.catId, this.name);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryProductsCubit()..getCatProductsData(catId, context),
      child: BlocConsumer<CategoryProductsCubit, CategoryProductsStates>(
          listener: (context, state) {
        if (state is CategorySuccessFavoritesState) {
          if (state.model.status == false) {
            showToast(text: '${state.model.message}', state: ToastStates.ERROR);
          }
        }
      }, builder: (context, state) {
        return BuildCondition(
            condition: ShopCubit.get(context).homeModel != null &&
                CategoryProductsCubit.get(context).categoryProductsModel !=
                    null,
            fallback: (contex) => Center(child: CircularProgressIndicator()),
            builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(name!),
                  ),
                  body: buildCatIem(context,
                      CategoryProductsCubit.get(context).categoryProductsModel),
                ));
      }),
    );
  }

  Widget buildCatIem(context, CategoryProductsModel? model) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color: Colors.grey[300],
          child: GridView.count(
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              shrinkWrap: true,
              childAspectRatio: 1 / 1.58,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(
                  CategoryProductsCubit.get(context)
                      .categoryProductsModel!
                      .data!
                      .data!
                      .length,
                  (index) => GestureDetector(
                        onTap: () {
                          navigateTo(
                              context,
                              ProductDetails(
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .name!,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .price,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .image!,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .description,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .id!,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .images!,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .oldPrice!,
                                  CategoryProductsCubit.get(context)
                                      .categoryProductsModel!
                                      .data!
                                      .data![index]
                                      .discount!));
                        },
                        child: buildGridProduct(
                            model!.data!.data![index], context),
                      ))),
        ),
      );

  Widget buildGridProduct(CategoryProucts model, context) => Container(
        color: !CacheHelper.getData(key: 'isDark')
            ? Colors.white
            : HexColor('131517'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Image(
                        image: NetworkImage('${model.image}'),
                        width: double.infinity,
                        height: 200.0,
                      ),
                      if (model.discount != 0)
                        Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            'DISCOUNT',
                            style:
                                TextStyle(fontSize: 8.0, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    '${model.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, height: 1.3),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price!.round()}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.0, color: defaultColor),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice!.round()}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            CategoryProductsCubit.get(context)
                                .changeFavorites(model.id!, context);
                          },
                          icon: CircleAvatar(
                            backgroundColor:
                                ShopCubit.get(context).favorites![model.id]!
                                    ? defaultColor
                                    : Colors.grey,
                            radius: 15.0,
                            child: Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                              size: 14.0,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
