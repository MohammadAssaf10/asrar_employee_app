import 'package:dartz/dartz.dart';

import '../../../../core/data/exception_handlers/failure.dart';
import '../../../auth/domain/entities/employee.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/repositories/service_order_repository.dart';

class FirebaseServiceOrderRepository extends ServiceOrderRepository{
  @override
  Future<Either<Failure, void>> acceptOrder(Employee employee, ServiceOrder serviceOrder) {
    // TODO: implement acceptOrder
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> cancelOrder(ServiceOrder serviceOrder) {
    // TODO: implement cancelOrder
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> finishOrder(ServiceOrder serviceOrder) {
    // TODO: implement finishOrder
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ServiceOrder>>> getEmployeeArchiveOrder(Employee employee) {
    // TODO: implement getEmployeeArchiveOrder
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ServiceOrder>>> getEmployeeCurrentOrders(Employee employee) {
    // TODO: implement getEmployeeCurrentOrders
    throw UnimplementedError();
  }
}