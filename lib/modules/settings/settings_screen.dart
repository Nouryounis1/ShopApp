import 'package:buildcondition/buildcondition.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shop_app/components/components.dart';
import 'package:shop_app/components/constants.dart';
import 'package:shop_app/cubit/cubit.dart';
import 'package:shop_app/cubit/states.dart';
import 'package:shop_app/modules/address/address_screen.dart';
import 'package:shop_app/modules/settings/account_settings.dart';
import 'package:shop_app/modules/settings/faqs_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).profileModel;
        return BuildCondition(
          condition: ShopCubit.get(context).profileModel != null,
          builder: (context) => SettingsList(
            backgroundColor: !CacheHelper.getData(key: 'isDark')
                ? Colors.white
                : HexColor('131517'),
            sections: [
              SettingsSection(
                tiles: [
                  SettingsTile(
                    titleTextStyle: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.white),
                    title: 'Account Settings',
                    subtitle: '${model!.data?.email!}',
                    subtitleTextStyle: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.white),
                    leading: CircleAvatar(
                      backgroundColor: defaultColor,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    onPressed: (BuildContext context) {
                      navigateTo(context, AccountSettingsScreen());
                    },
                  ),
                  SettingsTile(
                    titleTextStyle: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.white),
                    title: 'Address',
                    leading: CircleAvatar(
                      backgroundColor: defaultColor,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    onPressed: (BuildContext context) {
                      navigateTo(context, AddressScreen());
                    },
                  ),
                  SettingsTile(
                    titleTextStyle: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.white),
                    title: 'FAQs',
                    leading: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      child: Icon(
                        Icons.question_answer,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    onPressed: (BuildContext context) {
                      navigateTo(context, FAQsScreen());
                    },
                  ),
                  SettingsTile.switchTile(
                    titleTextStyle: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.white),
                    title: 'Dark Mode',
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.dark_mode,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    onToggle: (bool value) {
                      ShopCubit.get(context).changeDarkMode(value);
                    },
                    switchValue: CacheHelper.getData(key: 'isDark'),
                  ),
                  SettingsTile(
                    titleTextStyle: !CacheHelper.getData(key: 'isDark')
                        ? TextStyle(color: Colors.black)
                        : TextStyle(color: Colors.white),
                    title: 'Logout',
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                    onPressed: (BuildContext context) {
                      logOut(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<void> logOut(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We will be redirected to login page.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                signOut(context); // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }
}
