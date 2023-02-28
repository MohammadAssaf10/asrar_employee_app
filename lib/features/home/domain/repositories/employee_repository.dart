import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/data/failure.dart';
import '../../../auth/domain/entities/employee.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, Unit>> updateEmployeeImage(XFile image, Employee employee);
  Future<Either<Failure, Unit>> updateEmployeeInfo(
      Employee oldEmployee, String newEmail, String newName, String newPhoneNumber);
  Future<Either<Failure, Unit>> updatePassword(String newPassword);
}
