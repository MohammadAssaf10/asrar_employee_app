import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/app/constants.dart';
import '../../../../core/data/exception_handler.dart';
import '../../../../core/data/failure.dart';
import '../../../auth/domain/entities/employee.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/repositories/service_order_repository.dart';
import 'financial_entitlements_repository.dart';

class FirebaseServiceOrderRepository extends ServiceOrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> acceptOrder(Employee employee, ServiceOrder serviceOrder) async {
    try {
      serviceOrder = serviceOrder.copyWith(employee: employee, status: OrderStatus.inProgress.name);

      _firestore
          .collection(FireBaseConstants.serviceOrder)
          .doc(serviceOrder.id.toString())
          .update(serviceOrder.toMap());

      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> cancelOrder(ServiceOrder serviceOrder) async {
    try {
      await _firestore
          .collection(FireBaseConstants.serviceOrder)
          .doc(serviceOrder.id.toString())
          .update({"employee": null, 'status': 'pending'});

      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> finishOrder(ServiceOrder serviceOrder) async {
    await _firestore
        .collection(FireBaseConstants.serviceOrder)
        .doc(serviceOrder.id.toString())
        .update({"status": OrderStatus.completed.name});

    await FinancialEntitlementsRepository().addFinancialEntitlements(
        serviceOrder.employee, double.parse(serviceOrder.service.servicePrice));

    return const Right(null);
  }

  @override
  Future<Either<Failure, List<ServiceOrder>>> getEmployeeArchiveOrder(Employee employee) async {
    try {
      List<ServiceOrder> serviceOrderList = [];

      var docs = await _firestore
          .collection(FireBaseConstants.serviceOrder)
          .where(FireBaseConstants.employee, isEqualTo: employee.toMap())
          .get();

      for (var doc in docs.docs) {
        serviceOrderList.add(ServiceOrder.fromMap(doc.data()));
      }

      return Right(serviceOrderList);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ServiceOrder>>> getEmployeeCurrentOrders(Employee employee) async {
    try {
      List<ServiceOrder> serviceOrderList = [];

      var docs = await _firestore
          .collection(FireBaseConstants.serviceOrder)
          .where(FireBaseConstants.employee, isEqualTo: employee.toMap())
          .where(FireBaseConstants.status, isEqualTo: OrderStatus.inProgress.name)
          .get();

      for (var doc in docs.docs) {
        serviceOrderList.add(ServiceOrder.fromMap(doc.data()));
      }

      return Right(serviceOrderList);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ServiceOrder>>> getPendingOrders() async {
    try {
      List<ServiceOrder> serviceOrderList = [];

      var docs = await _firestore
          .collection(FireBaseConstants.serviceOrder)
          .where(FireBaseConstants.status, isEqualTo: OrderStatus.pending.name)
          .get();

      for (var doc in docs.docs) {
        serviceOrderList.add(ServiceOrder.fromMap(doc.data()));
      }

      return Right(serviceOrderList);
    } catch (e) {
      return Left(ExceptionHandler.handle(e).failure);
    }
  }
}
