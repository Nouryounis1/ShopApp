import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetails extends StatelessWidget {
  final String productName;
  final int productId;
  final String productImage;
  final dynamic productPrice;
  final dynamic productDescription;
  final List<dynamic> imageList;
  final dynamic oldPrice;
  final dynamic discount;
  var _pagecontroller = PageController();

  ProductDetails(
      this.productName,
      this.productPrice,
      this.productImage,
      this.productDescription,
      this.productId,
      this.imageList,
      this.oldPrice,
      this.discount);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: 25.0,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Hero(
                                tag: 'img',
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(24.0),
                                    height: MediaQuery.of(context).size.height *
                                        0.38,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: CarouselSlider.builder(
                                        itemCount: imageList.length,
                                        itemBuilder: (BuildContext context,
                                                int itemIndex,
                                                int pageViewIndex) =>
                                            Image(
                                                image: NetworkImage(
                                                    imageList[itemIndex])),
                                        options: CarouselOptions(
                                            height: 250.0,
                                            initialPage: 0,
                                            viewportFraction: 1.0,
                                            enableInfiniteScroll: true,
                                            reverse: false,
                                            autoPlay: true,
                                            onPageChanged: (index, reason) =>
                                                ShopCubit.get(context)
                                                    .changeIndicatorIndex(
                                                        index),
                                            autoPlayInterval:
                                                Duration(seconds: 3),
                                            autoPlayAnimationDuration:
                                                Duration(seconds: 1),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            scrollDirection: Axis.horizontal)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Center(
                                child: AnimatedSmoothIndicator(
                                  activeIndex:
                                      ShopCubit.get(context).activeIndex,
                                  count: imageList.length,
                                  effect: ExpandingDotsEffect(
                                      activeDotColor: defaultColor,
                                      dotColor: Color(0xFFababab),
                                      dotHeight: 4.8,
                                      dotWidth: 6,
                                      spacing: 4.8),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Text(
                                        productName,
                                        style:
                                            !CacheHelper.getData(key: 'isDark')
                                                ? TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    fontFamily: 'OpenSans')
                                                : TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    fontFamily: 'OpenSans'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: ReadMoreText(
                                        productDescription,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                          height: 1.40,
                                        ),
                                        trimLines: 5,
                                        colorClickableText: defaultColor,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                        moreStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: defaultColor),
                                      ),
                                    ),
                                    Container(
                                      height: 90.0,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin:
                                                EdgeInsets.only(right: 15.0),
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "\$${(productPrice.round())}",
                                                  style: !CacheHelper.getData(
                                                          key: 'isDark')
                                                      ? TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                          fontFamily:
                                                              'OpenSans-Bold')
                                                      : TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.0,
                                                          fontFamily:
                                                              'OpenSans-Bold'),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                if (discount != 0)
                                                  Text(
                                                    '${oldPrice!.round()}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.grey,
                                                        fontFamily:
                                                            'OpenSans-Bold',
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: defaultColor),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              child: IconButton(
                                                onPressed: () {
                                                  ShopCubit.get(context)
                                                      .changeFavorites(
                                                          productId);
                                                },
                                                icon: ShopCubit.get(context)
                                                        .favorites![productId]!
                                                    ? Icon(
                                                        Icons.favorite,
                                                        color: defaultColor,
                                                      )
                                                    : Icon(
                                                        Icons.favorite_border,
                                                        color: defaultColor,
                                                      ),
                                              )),
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              ShopCubit.get(context)
                                                  .changeCart(productId);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: !ShopCubit.get(context)
                                                          .cart![productId]!
                                                      ? defaultColor
                                                      : Colors.red),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    !ShopCubit.get(context)
                                                            .cart![productId]!
                                                        ? Icon(
                                                            Icons.shopping_bag,
                                                            color: Colors.white,
                                                          )
                                                        : Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    !ShopCubit.get(context)
                                                            .cart![productId]!
                                                        ? Text(
                                                            "Add to cart",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans-Bold'),
                                                          )
                                                        : Text(
                                                            "Remove from cart",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans-Bold'),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
