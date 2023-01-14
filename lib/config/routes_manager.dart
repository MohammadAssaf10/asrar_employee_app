import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/auth_view.dart';
import '../splash.dart';
import 'strings_manager.dart';

class Routes {
  // home route
  static const String splashRoute = "/";

  static const String homeRoute = "/home";

  // auth rotes
  static const String auth = '/auth';
}

class RouteGenerator {
  static Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));

      case Routes.auth:
        return MaterialPageRoute(builder: ((context) => const Auth()));

      default:
        return unDefinedRoute();
    }
  }

  static Route unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.noRouteFound,
          ),
        ),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
