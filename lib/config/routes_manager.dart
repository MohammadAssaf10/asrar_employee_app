import 'package:flutter/material.dart';


import 'strings_manager.dart';

class Routes {
  // home route
  static const String homeRoute = "/";

  // auth rotes
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String resetPassword = '/resetPassword';
}

class RouteGenerator {
  static Route getRoute(RouteSettings settings) {
    switch (settings.name) {

      default:
        return unDefinedRoute();
    }
  }

  static Route unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.noRouteFound,
          ),
        ),
        body: Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
