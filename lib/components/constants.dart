import 'package:shop_app/components/components.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (true) {
      navigateAndFinish(context, LoginScreen());
    }
  });
}

String? token;
bool? isDarkmode;
