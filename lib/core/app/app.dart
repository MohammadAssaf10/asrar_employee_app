import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/app_localizations.dart';
import '../../config/routes_manager.dart';
import '../../config/theme_manager.dart';
import '../../features/auth/data/data_sources/auth_prefs.dart';
import '../../features/auth/presentation/bloc/authentication_bloc.dart';
import '../../features/chat/presentation/blocs/support_chat/support_chat_bloc.dart';
import '../../features/home/presentation/blocs/employee_bloc/employee_bloc.dart';
import '../../features/home/presentation/blocs/my_wallet_bloc/my_wallet_bloc.dart';
import '../../features/home/presentation/blocs/notification_bloc/notification_bloc.dart';
import '../../features/home/presentation/blocs/service_order_bloc/service_order_bloc.dart';
import '../../language_cubit/language_cubit.dart';
import 'di.dart';
import 'language.dart';

class MyApp extends StatelessWidget {
  // named constructor
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal(); // singleton or single instance

  factory MyApp() => _instance; // factory
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
        BlocProvider<ServiceOrderBloc>(create: (context) => ServiceOrderBloc()),
        BlocProvider<MyWalletBloc>(create: (context) => MyWalletBloc()),
        BlocProvider<EmployeeBloc>(create: (context) => EmployeeBloc()),
        BlocProvider<NotificationBloc>(create: (context) => NotificationBloc()),
        BlocProvider<SupportChatBloc>(create: (context) => SupportChatBloc()),
        BlocProvider<AuthenticationBloc>(
            lazy: false, create: (context) => AuthenticationBloc.instance..add(AppStarted()))
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "اسرار",
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalizations.delegate,
                ],
                supportedLocales: const [arabicLocale, englishLocale],
                locale: state.locale,
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (deviceLocale != null && deviceLocale.languageCode == locale.languageCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                theme: getApplicationTheme(),
                onGenerateRoute: RouteGenerator.getRoute,
                initialRoute:
                    (instance<AuthPreferences>().isUserLoggedIn()) ? Routes.homeRoute : Routes.auth,
              );
            },
          );
        },
      ),
    );
  }
}
