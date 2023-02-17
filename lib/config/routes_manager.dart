import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/app/di.dart';
import '../features/auth/presentation/pages/auth_view.dart';
import '../features/auth/presentation/pages/password_reset_view.dart';
import '../features/auth/presentation/pages/sign_in_view.dart';
import '../features/auth/presentation/pages/sign_up_view.dart';
import '../features/chat/presentation/blocs/chat_bloc/chat_bloc.dart';
import '../features/chat/presentation/pages/chat_screen.dart';
import '../features/home/domain/entities/service_order.dart';
import '../features/home/presentation/pages/main/main_view.dart';
import '../splash.dart';
import 'strings_manager.dart';

class Routes {
  // home route
  static const String splashRoute = "/";

  static const String homeRoute = "/home";
  static const String chatRoute = "/chat";

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
        return MaterialPageRoute(builder: (_) => const MainView());

      case Routes.chatRoute:
        {
          final arg = settings.arguments as ServiceOrder;
          initChatModule(arg);

          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatBloc()..add(ChatStarted(serviceOrder: arg)),
              lazy: false,
              child: const ChatScreen(),
            ),
          );
        }
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
