import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/data/failure.dart';
import '../../data/requests/employees_updates.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, Unit>> updateEmployeeImage(EmployeeUpdatesRequest employeeUpdates, XFile xFile);
  Future<Either<Failure, Unit>> updateEmployeeInfo(
      EmployeeUpdatesRequest employeeUpdates, String newEmail);
  Future<Either<Failure, Unit>> updatePassword(String newPassword);
  Future<Either<Failure, List<String>>> getEmployeeTokenList();
}
