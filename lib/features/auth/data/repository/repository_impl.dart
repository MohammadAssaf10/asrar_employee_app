import 'package:dartz/dartz.dart';

import '../../../../core/data/exception_handlers/exception_handler.dart';
import '../../../../core/data/exception_handlers/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repository/repository.dart';
import '../data_sources/firebase_auth_helper.dart';
import '../models/requests.dart';

class RepositoryImp implements AuthRepository {
  final FirebaseAuthHelper _firebaseHelper;
  final NetworkInfo _networkInfo;

  RepositoryImp(this._firebaseHelper, this._networkInfo);

  @override
  Future<Either<Failure, Employee>> login(LoginRequest loginRequest) async {
    // check internet connection
    if (!(await _networkInfo.isConnected)) {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }

    try {
      return Right(await _firebaseHelper.login(loginRequest));
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
      return Right(await _firebaseHelper.register(registerRequest));
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _firebaseHelper.resetPassword(email);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, Employee?>> getCurrentUserIfExists() {
    // TODO: implement getCurrentUserIfExists
    throw UnimplementedError();
  }
}
