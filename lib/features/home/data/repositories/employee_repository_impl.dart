import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/app/constants.dart';
import '../../../../core/app/di.dart';
import '../../../../core/app/functions.dart';
import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/data_sources/firebase_auth_helper.dart';
import '../../../auth/domain/entities/employee.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../chat/domain/entities/file_entities.dart';
import '../../domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl extends EmployeeRepository {
  final FirebaseAuthHelper _authHelper = instance<FirebaseAuthHelper>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthRepository authRepository;
  final NetworkInfo networkInfo;
  EmployeeRepositoryImpl({required this.networkInfo, required this.authRepository});

  @override
  Future<Either<Failure, Unit>> updateEmployeeImage(XFile image, Employee employee) async {
    if (await networkInfo.isConnected) {
      try {
        final path = "${FireBaseConstants.employees}/${employee.employeeID}";
        if (employee.imageName.isNotEmpty && employee.imageURL.isNotEmpty) {
          await deleteFile("$path/${employee.imageName}");
        }
        final FileEntities file =
        await uploadFile("$path/${image.name}", image);
        employee = employee.copyWith(imageName: file.name, imageURL: file.url);
        await firestore
            .collection(employeeCollectionPath)
            .doc(employee.employeeID)
            .update(employee.toMap());
        return const Right(unit);
      } catch (e) {
        return Left(ExceptionHandler.handle(e).failure);
      }
    } else {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updatePassword(String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final user = _authHelper.getCurrentUser();
        await user?.updatePassword(newPassword);
        return const Right(unit);
      } catch (e) {
        return Left(ExceptionHandler.handle(e).failure);
      }
    } else {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEmployeeInfo(Employee oldEmployee, String newEmail,
      String newName, String newPhoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final user = _authHelper.getCurrentUser();
        await user?.updateEmail(newEmail);
        oldEmployee = oldEmployee.copyWith(
          name: newName,
          email: newEmail,
          phoneNumber: newPhoneNumber,
        );
        await authRepository.updateEmployeeData(oldEmployee);
        return const Right(unit);
      } catch (e) {
        return Left(ExceptionHandler.handle(e).failure);
      }
    } else {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }
  }
}
