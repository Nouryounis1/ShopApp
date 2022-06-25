import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_board_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/cubit.dart';
import 'package:shop_app/styles/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  token = CacheHelper.getData(key: 'token');
  print(token);
  Widget widget;
  bool isSkipped = false;

  if (isSkipped != null) {
    if (token != null) {
      widget = ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = onBoardingScreen();
  }

  if (CacheHelper.getData(key: 'isDark') == null) {
    CacheHelper.saveData(key: 'isDark', value: false);
  }

  runApp(MyApp(isSkipped, widget));
}

class MyApp extends StatelessWidget {
  final bool isSkipped;
  final Widget startWidget;

  MyApp(this.isSkipped, this.startWidget);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavorites()
              ..getCart()
              ..getPorfile()
              ..getFAQs()
              ..getNotifications()
              ..getAddress()),
      ],
      child: BlocConsumer<ShopCubit, ShopStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: !CacheHelper.getData(key: 'isDark')
                  ? ThemeMode.light
                  : ThemeMode.dark,
              home: startWidget,
            );
          }),
    );
  }
}
