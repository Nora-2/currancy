import 'package:currency/src/core/utils/app_colors.dart';
import 'package:currency/src/core/utils/app_string.dart';
import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.hint,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: AppString.fontname1,
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20)),
      );
}
