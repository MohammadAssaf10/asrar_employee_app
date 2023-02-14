import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/data_sources/auth_prefs.dart';
import '../../features/auth/data/data_sources/firebase_auth_helper.dart';
import '../../features/auth/data/repository/firebase_auth_repository.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/home/data/repositories/firebase_service_order_repository.dart';
import '../../features/home/domain/repositories/service_order_repository.dart';
import '../network/network_info.dart';

final GetIt instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared pref instance
  final sharedPref = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPref);

  // auth pref instance
  instance
      .registerLazySingleton<AuthPreferences>(() => AuthPreferences(instance<SharedPreferences>()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));

  instance.registerLazySingleton<FirebaseAuthHelper>(() => FirebaseAuthHelper());
}

void initAuthenticationModule() {
  if (!GetIt.I.isRegistered<AuthRepository>()) {
    instance.registerLazySingleton<AuthRepository>(
        () => FirebaseAuthRepository(instance(), instance()));
  }
}

void initHomeModule() {
  if (!GetIt.I.isRegistered<ServiceOrderRepository>()) {
    instance.registerLazySingleton<ServiceOrderRepository>(() => FirebaseServiceOrderRepository());
  }
}
