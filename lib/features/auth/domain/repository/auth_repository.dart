import 'package:dartz/dartz.dart';

import '../../../../core/data/exception_handlers/failure.dart';
import '../../data/models/requests.dart';
import '../entities/employee.dart';

abstract class AuthRepository {
  Future<Either<Failure, Employee>> login(LoginRequest loginRequest);
  Future<Either<Failure, Employee>> register(RegisterRequest registerRequest);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, Employee?>> getCurrentUserIfExists();
  Future<Either<Failure, void>> logout();
  Future<void> deleteEmployee(String email);
}
