
import 'package:currency/src/config/routes/app_routes.dart';
import 'package:currency/src/config/themes/app_theme.dart';
import 'package:currency/src/core/utils/app_string.dart';
import 'package:flutter/material.dart';

class CurrancyApp extends StatelessWidget {
  const CurrancyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      theme:appTheme(),
       onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
