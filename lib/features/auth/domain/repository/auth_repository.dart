import 'package:dartz/dartz.dart';

import '../../../../core/data/failure.dart';
import '../../data/models/requests.dart';
import '../entities/employee.dart';

abstract class AuthRepository {
  Future<Either<Failure, Employee>> login(LoginRequest loginRequest);
  Future<Either<Failure, Employee>> register(RegisterRequest registerRequest);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, Employee?>> getCurrentUserIfExists();
  Future<Either<Failure, void>> logout(String employeeID);
  Future<void> deleteEmployee(String id);
}
