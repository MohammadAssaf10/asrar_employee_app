import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_prefs.dart';
import '../data_sources/firebase_auth_helper.dart';
import '../models/requests.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuthHelper _authHelper;
  final NetworkInfo _networkInfo;
  final AuthPreferences _authPreference;

  FirebaseAuthRepository(
      this._authHelper, this._networkInfo, this._authPreference);

  @override
  Future<Either<Failure, Employee>> login(LoginRequest loginRequest) async {
    // check internet connection
    if (!(await _networkInfo.isConnected)) {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }

    try {
      return Right(await _authHelper.login(loginRequest));
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Employee>> register(
      RegisterRequest registerRequest) async {
    // check internet connection
    if (!(await _networkInfo.isConnected)) {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }

    try {
      return Right(await _authHelper.register(registerRequest));
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _authHelper.resetPassword(email);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, Employee?>> getCurrentUserIfExists() async {
    try {
      User? user = _authHelper.getCurrentUser();

      if (user == null || user.email == null) return const Right(null);

      Employee employee = await _authHelper.getEmployee(user.email!);

      return Right(employee);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> logout(String employeeID) async {
    try {
      await _authHelper.deleteUserToken(employeeID);
      await _authHelper.logout();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await _authHelper.deleteUser();
    await _authHelper.deleteEmployeeData(id);
    await _authHelper.deleteEmployeeImages(id);
  }

  // this method called in every signIn or registering
  // because if it from google it can be the first sign in
  @override
  Future<Either<Failure, Employee>> updateEmployeeData(
      Employee employee) async {
    try {
      employee.employeeTokenList = await _authHelper.addUserToken(employee.email);
      _authPreference.setUserLoggedIn();
      _authPreference.setEmployee(employee);

      return Right(await _authHelper.updateEmployeeData(employee));
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }
}
