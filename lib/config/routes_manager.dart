import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/auth_view.dart';
import '../features/auth/presentation/pages/password_reset_view.dart';
import '../features/auth/presentation/pages/sign_in_view.dart';
import '../features/auth/presentation/pages/sign_up_view.dart';
import '../features/home/presentation/pages/main/main_view.dart';
import '../splash.dart';
import 'strings_manager.dart';

class Routes {
  // home route
  static const String splashRoute = "/";

  static const String homeRoute = "/home";

  // auth rotes
  static const String auth = '/auth';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String passwordReset = '/passwordReset';
}

class RouteGenerator {
  static Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: ((context) => const SplashScreen()));

      case Routes.auth:
        return MaterialPageRoute(builder: ((context) => const Auth()));

      case Routes.signIn:
        return MaterialPageRoute(builder: ((context) => const SignIn()));

      case Routes.signUp:
        return MaterialPageRoute(builder: ((context) => const SignUp()));

      case Routes.passwordReset:
        return MaterialPageRoute(builder: ((context) => PasswordResetView()));

        case Routes.homeRoute:
        // initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());

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
