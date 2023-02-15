import 'package:dartz/dartz.dart';

import '../../../../core/data/exception_handlers/failure.dart';
import '../../../auth/domain/entities/employee.dart';
import '../entities/service_order.dart';

abstract class ServiceOrderRepository {
  Future<Either<Failure, List<ServiceOrder>>> getEmployeeCurrentOrders(Employee employee);
  Future<Either<Failure, List<ServiceOrder>>> getEmployeeArchiveOrder(Employee employee);
  Future<Either<Failure, List<ServiceOrder>>> getPendingOrders();
  Future<Either<Failure, void>> acceptOrder(Employee employee ,ServiceOrder serviceOrder);
  Future<Either<Failure, void>> finishOrder(ServiceOrder serviceOrder);
  Future<Either<Failure, void>> cancelOrder(ServiceOrder serviceOrder);
}
