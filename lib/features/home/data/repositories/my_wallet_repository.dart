import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../../auth/domain/entities/employee.dart';
import '../../domain/entities/my_wallet.dart';
import 'financial_entitlements_repository.dart';

class MyWalletRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Either<Failure, MyWallet>> getData(Employee employee) async {
    try {
      MyWallet myWallet = MyWallet.fromMap(
          (await _firestore.collection(kFinancialEntitlements).doc(employee.employeeID).get())
                  .data() ??
              {});

      myWallet = myWallet.copyWith(
          appNet: double.parse(
              ((await _firestore.collection('net').doc('appNet').get()).data()?['appNet'] ?? 0)
                  .toString()));

      return Right(myWallet);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }
}
