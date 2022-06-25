import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/notification/notification_screen.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

class ShopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          navigateTo(context, SearchScreen());
                        },
                        icon: Icon(
                          Icons.search,
                        )),
                    IconButton(
                        onPressed: () {
                          navigateTo(context, NotificationScreen());
                        },
                        icon: Stack(
                          children: [
                            Icon(Icons.notifications),
                            Positioned(
                                left: 16.0,
                                child: Icon(
                                  Icons.brightness_1,
                                  size: 9.0,
                                  color: Colors.red,
                                ))
                          ],
                        )),
                  ],
                ),
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: !CacheHelper.getData(key: 'isDark')
                  ? Colors.white
                  : Colors.black,
              selectedIndex: cubit.currentIndex,
              showElevation: true,
              itemCornerRadius: 24,
              curve: Curves.easeIn,
              onItemSelected: (index) {
                cubit.changeBottom(index);
              },
              items: <BottomNavyBarItem>[
                BottomNavyBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                  activeColor: defaultColor,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.shopping_bag),
                  title: Text('Cart'),
                  activeColor: defaultColor,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text(
                    'Favorites',
                  ),
                  inactiveColor: Colors.grey,
                  activeColor: defaultColor,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                  activeColor: defaultColor,
                  inactiveColor: Colors.grey,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        });
  }
}
