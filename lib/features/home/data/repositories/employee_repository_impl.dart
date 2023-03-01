import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/app/di.dart';
import '../../../../core/app/functions.dart';
import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/data_sources/firebase_auth_helper.dart';
import '../../../chat/domain/entities/file_entities.dart';
import '../../domain/repositories/employee_repository.dart';
import '../requests/employees_updates.dart';

const String employeesUpdates = "EmployeesUpdates";

class EmployeeRepositoryImpl extends EmployeeRepository {
  final FirebaseAuthHelper _authHelper = instance<FirebaseAuthHelper>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final NetworkInfo networkInfo;

  EmployeeRepositoryImpl({required this.networkInfo});

  @override
  Future<Either<Failure, Unit>> updateEmployeeImage(
      EmployeeUpdatesRequest employeeUpdates, XFile xFile) async {
    if (await networkInfo.isConnected) {
      try {
        final path = "$employeesUpdates/${employeeUpdates.employeeID}";
        final FileEntities file =
            await uploadFile("$path/${employeeUpdates.newImageName}", xFile);
        employeeUpdates = employeeUpdates.copyWith(newImageURL: file.url);
        final employeeUpdatesDoc = await firestore
            .collection(employeesUpdates)
            .doc(employeeUpdates.employeeID)
            .get();
        if (employeeUpdatesDoc.exists) {
          await firestore
              .collection(employeesUpdates)
              .doc(employeeUpdates.employeeID)
              .update({
            "newImageName": employeeUpdates.newImageName,
            "newImageURL": employeeUpdates.newImageURL,
            "oldImageName": employeeUpdates.oldImageName,
            "oldImageURL": employeeUpdates.oldImageURL,
          });
        } else {
          await firestore
              .collection(employeesUpdates)
              .doc(employeeUpdates.employeeID)
              .set(employeeUpdates.toMap());
        }

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
  Future<Either<Failure, Unit>> updateEmployeeInfo(
      EmployeeUpdatesRequest employeeUpdates, String newEmail) async {
    if (await networkInfo.isConnected) {
      try {
        final user = _authHelper.getCurrentUser();
        await user?.updateEmail(newEmail);
        await firestore
            .collection(employeeCollectionPath)
            .doc(employeeUpdates.employeeID)
            .update({'email': newEmail});
        final employeeUpdatesDoc = await firestore
            .collection(employeesUpdates)
            .doc(employeeUpdates.employeeID)
            .get();
        if (employeeUpdatesDoc.exists) {
          await firestore
              .collection(employeesUpdates)
              .doc(employeeUpdates.employeeID)
              .update({
            "newName": employeeUpdates.newName,
            "oldName": employeeUpdates.oldName,
            "oldPhoneNumber": employeeUpdates.oldPhoneNumber,
            "newPhoneNumber": employeeUpdates.newPhoneNumber,
            "timeStamp": employeeUpdates.timeStamp,
          });
        } else {
          await firestore
              .collection(employeesUpdates)
              .doc(employeeUpdates.employeeID)
              .set(employeeUpdates.toMap());
        }
        return const Right(unit);
      } catch (e) {
        return Left(ExceptionHandler.handle(e).failure);
      }
    } else {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getEmployeeTokenList() async {
    if (await networkInfo.isConnected) {
      try {
        List<String> employeeTokenList = [];
        final employeesDoc =
            await firestore.collection(employeeCollectionPath).get();
        for (var employee in employeesDoc.docs) {
          for (String employeeToken in employee['employeeTokenList']) {
            employeeTokenList.add(employeeToken);
          }
        }
        return Right(employeeTokenList);
      } catch (e) {
        return Left(ExceptionHandler.handle(e).failure);
      }
    } else {
      return Left(DataSourceExceptions.noInternetConnections.getFailure());
    }
  }
}
