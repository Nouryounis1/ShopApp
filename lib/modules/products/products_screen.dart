import 'package:buildcondition/buildcondition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories_products/categories_products.dart';
import 'package:shop_app/modules/product_detials/products_details_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  List<FaIcon> categorieIcons = [
    FaIcon(FontAwesomeIcons.tabletAlt, color: defaultColor),
    FaIcon(FontAwesomeIcons.briefcaseMedical, color: defaultColor),
    FaIcon(FontAwesomeIcons.dumbbell, color: defaultColor),
    FaIcon(FontAwesomeIcons.lightbulb, color: defaultColor),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessFavoritesState) {
          if (state.model.status == false) {
            showToast(text: '${state.model.message}', state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        var ss = ShopCubit.get(context).homeModel;
        return BuildCondition(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel,
              ShopCubit.get(context).categoriesModel,
              context),
          fallback: (contex) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel? model, CategoriesModel? categoriesModel, context) =>
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                items: model?.data!.banners
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image(
                                  image: NetworkImage('${e.image}'),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                    height: 250.0,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal)),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)
                        : TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                navigateTo(
                                    context,
                                    CategoryProductsScreen(
                                        categoriesModel!.data!.data[index].id!,
                                        categoriesModel
                                            .data!.data[index].name!));
                                print(categoriesModel.data!.data[index].id!);
                              },
                              child: buildCategoryItem(
                                  categoriesModel!.data!.data[index]),
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              width: 10.0,
                            ),
                        itemCount: categoriesModel!.data!.data.length),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)
                        : TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              child: GridView.count(
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  shrinkWrap: true,
                  childAspectRatio: 1 / 1.58,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(
                      model!.data!.products.length,
                      (index) => GestureDetector(
                            onTap: () {
                              navigateTo(
                                  context,
                                  ProductDetails(
                                      model.data!.products[index].name!,
                                      model.data!.products[index].price,
                                      model.data!.products[index].image!,
                                      model.data!.products[index].description,
                                      model.data!.products[index].id!,
                                      model.data!.products[index].images!,
                                      model.data!.products[index].oldPrice!,
                                      model.data!.products[index].discount!));
                            },
                            child: buildSingleItem(
                                model.data!.products[index], context),
                          ))),
            )
          ],
        ),
      );

  Widget buildCategoryItem(DataModel model) => Container(
        width: 100.0,
        height: 100.0,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage('${model.image}'),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
                child: Text(
                  '${model.name}',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model, context) => Container(
        color: Colors.white,
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
                        '${model.price.round()}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.0, color: defaultColor),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice.round()}',
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
                            ShopCubit.get(context).changeFavorites(model.id!);
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

  Widget buildSingleItem(ProductModel model, context) => Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset.zero,
              blurRadius: 10.0,
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 55),
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.bottomCenter,
                        image: NetworkImage('${model.image}'),
                      ),
                    ),
                  ),
                  if (model.discount != 0)
                    Positioned(
                      top: 7,
                      right: 10,
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: defaultColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '-${model.discount}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' \$ ${model.price.round()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: defaultColor,
                          height: 1.5,
                        ),
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice.round()}',
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.black38,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget buildGridITem(ProductModel model, context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            overflow: Overflow.clip,
            children: <Widget>[
              Hero(
                  tag: "product_${model.name}",
                  child: Container(
                    child: Image.network(
                      '${model.image}',
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                color: Color(0x47000000),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        model.name!,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '\$ ${model.price.round()}',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.0),
                          ),
                          InkWell(
                            onTap: () {
                              ShopCubit.get(context).changeFavorites(model.id!);
                            },
                            child: Icon(
                              Icons.favorite,
                              color:
                                  ShopCubit.get(context).favorites![model.id]!
                                      ? Colors.redAccent
                                      : Colors.white,
                              size: 16.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
