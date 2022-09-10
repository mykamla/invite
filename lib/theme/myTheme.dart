import 'package:flutter/material.dart';

const PrimaryColor = const Color(0xFF5f478b);
const PrimaryColorLight = const Color(0xFF7250a5);
const PrimaryColorDark = const Color(0xFF2c1759);

const SecondaryColor = const Color(0xFFf4ff81);
const SecondaryColorLight = const Color(0xFFffffb3);
const SecondaryColorDark = const Color(0xFFbfcc50);

/*
const PrimaryColor = const Color(0xFF008080);
const PrimaryColorLight = const Color(0xFF4cb0af);
const PrimaryColorDark = const Color(0xFF005354);

const SecondaryColor = const Color(0xFFb2dfdb);
const SecondaryColorLight = const Color(0xFFe5ffff);
const SecondaryColorDark = const Color(0xFF82ada9);
*/

Map<int, Color> primary_color =
{
  50:Color(0xFFe8e5ef),
  100:Color(0xFFc7bed6),
  200:Color(0xFFa193bb),
  300:Color(0xFF7b679f),
  400:Color(0xFF5f478b),
  500:Color(0xFF432676),
  600:Color(0xFF3d226e),
  700:Color(0xFF341c63),
  800:Color(0xFF2c1759),
  900:Color(0xFF1e0d46),
};

MaterialColor PrimarySwatch = MaterialColor(0xFF5f478b, primary_color);
var PrimaryColor50 = PrimarySwatch[50];
var PrimaryColor100 = PrimarySwatch[100];
var PrimaryColor200 = PrimarySwatch[200];
var PrimaryColor300 = PrimarySwatch[300];
var PrimaryColor400 = PrimarySwatch[400];
var PrimaryColor500 = PrimarySwatch[500];
var PrimaryColor600 = PrimarySwatch[600];
var PrimaryColor700 = PrimarySwatch[700];
var PrimaryColor800 = PrimarySwatch[800];
var PrimaryColor900 = PrimarySwatch[900];

const Background = const Color(0xFFfffdf7);
const DarkBackground = const Color(0xFF222727);

const TextColor = const Color(0xFF004d40);

class MyTheme {
  static final ThemeData defaultTheme = _buildLightTheme();
  static final ThemeData darkTheme = _buildDarkTheme();

  static ThemeData _buildLightTheme() {


    final ThemeData base = ThemeData.light();


    return base.copyWith(
      primaryColor: PrimaryColor,
      primaryColorDark: PrimaryColorDark,
      primaryColorLight: PrimaryColorLight,

      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: SecondaryColor,
        textTheme: ButtonTextTheme.primary,
      ),

      scaffoldBackgroundColor: Background,
      cardColor: Background,
      backgroundColor: Background,

      textTheme: base.textTheme.copyWith(
          titleSmall: base.textTheme.titleSmall!.copyWith(color: TextColor),
          titleMedium: base.textTheme.titleMedium!.copyWith(color: TextColor),
          titleLarge: base.textTheme.titleLarge!.copyWith(color: TextColor),
          bodySmall: base.textTheme.bodySmall!.copyWith(color: TextColor),
          bodyMedium: base.textTheme.bodyMedium!.copyWith(color: TextColor),
          bodyLarge: base.textTheme.bodyLarge!.copyWith(color: TextColor),
      ),
    );
  }

  static ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData.dark();

    return base.copyWith(

        primaryColor: PrimaryColor,
        primaryColorDark: PrimaryColorDark,
        primaryColorLight: PrimaryColorLight,

        buttonTheme: base.buttonTheme.copyWith(
          buttonColor: SecondaryColor,
          textTheme: ButtonTextTheme.primary,
        ),

        scaffoldBackgroundColor: DarkBackground,
        cardColor: DarkBackground,
        backgroundColor: Background,

        textTheme: base.textTheme.copyWith(
          titleSmall: base.textTheme.titleSmall!.copyWith(color: TextColor),
          titleMedium: base.textTheme.titleMedium!.copyWith(color: TextColor),
          titleLarge: base.textTheme.titleLarge!.copyWith(color: TextColor),
          bodySmall: base.textTheme.bodySmall!.copyWith(color: TextColor),
          bodyMedium: base.textTheme.bodyMedium!.copyWith(color: TextColor),
          bodyLarge: base.textTheme.bodyLarge!.copyWith(color: TextColor),
    ),
    );
  }
}