import 'package:currency/src/core/utils/app_string.dart';
import 'package:currency/src/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String initialRoute = '/';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (context) {
          return const SplashView();
        });

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: ((context) => const Scaffold(
              body: Center(
                child: Text(AppString.noRouteFound),
              ),
            )));
  }
}
