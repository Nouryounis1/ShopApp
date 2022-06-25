import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop_app/styles/colors.dart';

ThemeData darkTheme = ThemeData(
    fontFamily: 'Jannah',
    scaffoldBackgroundColor: HexColor('131517'),
    primarySwatch: defaultColor,
    appBarTheme: AppBarTheme(
      titleSpacing: 20.0,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: HexColor('131517'),
          statusBarIconBrightness: Brightness.light),
      backgroundColor: HexColor('131517'),
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        elevation: 20.0,
        unselectedItemColor: Colors.grey,
        backgroundColor: HexColor('131517')),
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white)));

ThemeData lightTheme = ThemeData(
    fontFamily: 'Jannah',
    primarySwatch: defaultColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        elevation: 20.0),
    textTheme: TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black)));
