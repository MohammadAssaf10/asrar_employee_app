import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/data_sources/auth_prefs.dart';
import '../../features/auth/data/data_sources/firebase_auth_helper.dart';
import '../../features/auth/data/repository/firebase_auth_repository.dart';
import '../../features/auth/domain/entities/employee.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/chat/data/repositories/firebase_chat_repository.dart';
import '../../features/chat/data/repositories/support_chat_repository.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/home/data/repositories/employee_repository_impl.dart';
import '../../features/home/data/repositories/firebase_service_order_repository.dart';
import '../../features/home/data/repositories/notification_repository_impl.dart';
import '../../features/home/domain/entities/service_order.dart';
import '../../features/home/domain/repositories/employee_repository.dart';
import '../../features/home/domain/repositories/notification_repository.dart';
import '../../features/home/domain/repositories/service_order_repository.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';

final GetIt instance = GetIt.instance;

Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared pref instance
  final sharedPref = await SharedPreferences.getInstance();

  instance.registerLazySingleton<SharedPreferences>(() => sharedPref);
  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory());

  // auth pref instance
  instance
      .registerLazySingleton<AuthPreferences>(() => AuthPreferences(instance<SharedPreferences>()));

  // network info
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));

  instance.registerLazySingleton<FirebaseAuthHelper>(
      () => FirebaseAuthHelper(authPreferences: instance()));
  instance.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(networkInfo: instance<NetworkInfo>()),
  );
  instance.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(networkInfo: instance<NetworkInfo>()),
  );
}

void initAuthenticationModule() {
  if (!GetIt.I.isRegistered<AuthRepository>()) {
    instance.registerLazySingleton<AuthRepository>(
        () => FirebaseAuthRepository(instance(), instance(), instance()));
  }
}

void initHomeModule() {
  if (!GetIt.I.isRegistered<ServiceOrderRepository>()) {
    instance.registerLazySingleton<ServiceOrderRepository>(() => FirebaseServiceOrderRepository());
  }
}

void initSupportChatModule(Employee employee) {
  instance.registerLazySingleton<SupportChatRepository>(() {
    return SupportChatRepository(FirebaseFirestore.instance, instance<NetworkInfo>(), employee);
  });
}

void initChatModule(ServiceOrder serviceOrder) {
  if (instance.isRegistered<ChatRepository>()) {
    instance.unregister<ChatRepository>();
  }

  instance.registerFactory<ChatRepository>(() =>
      FirebaseChatRepository(FirebaseFirestore.instance, instance<NetworkInfo>(), serviceOrder));
}
