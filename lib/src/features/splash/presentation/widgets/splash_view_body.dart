// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:currency/src/core/utils/app_assets.dart';
import 'package:currency/src/core/utils/app_colors.dart';
import 'package:currency/src/core/utils/app_string.dart';
import 'package:currency/src/features/currency/presentation/views/currencyscreen.dart';
import 'package:flutter/material.dart';
class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});
  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}
class _SplashViewBodyState extends State<SplashViewBody> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  @override
  void initState() {
    super.initState();
    navigateToOnBoarding();
  }
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image(image: AssetImage(AppImages.welcome)),
        SizedBox(height: 3.0),
         Padding(
          padding:const EdgeInsets.only(top:40,left: 20),
          child: Text( AppString.welcome1, style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: AppString.fontname1,letterSpacing: 1),)
          
        ),
         Padding(
          padding: const EdgeInsets.only(top:5,left: 20),
          child:Text(AppString.welcome2, style:const  TextStyle(fontSize: 16,letterSpacing: 2,color: AppColors.hint),))
      ],
    );
  }
 
  void navigateToOnBoarding() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
        
          context,
          
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 1505),
            pageBuilder: (context, animation, secondaryAnimation) => CurrencyExchangePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            
          ),
          
          (route) => false,
        );
      }
    });
  }
}