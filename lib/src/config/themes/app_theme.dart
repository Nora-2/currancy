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
             
               datePickerTheme: DatePickerThemeData(
                todayBorder: BorderSide(color: AppColors.primaryColor),
                confirmButtonStyle: ButtonStyle(textStyle: WidgetStateProperty.all<TextStyle>(
                     TextStyle(color: Colors.black))),
                cancelButtonStyle: ButtonStyle(textStyle: WidgetStateProperty.all<TextStyle>(
                     TextStyle(color: Colors.black))),
      backgroundColor: Colors.white,
    
      headerBackgroundColor: AppColors.primaryColor,
      dayOverlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.black; // selected date background
          }
          return null;
        },
      ),
      todayBackgroundColor: WidgetStateColor.resolveWith( (Set<WidgetState> states) {
         {
          return AppColors.black; // background color on today date
        }
        
       
      }),
      todayForegroundColor:WidgetStateColor.resolveWith( (Set<WidgetState> states) {
         {
          return AppColors.primaryColor; // text color on today date
        }
        
       
      }),
    
      dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryColor; // selected date background
          }
          return null;
        },
      ),
      dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // text color on selected date
          }
          return null;
        },
      ),
    ),
  );

      
      
}
