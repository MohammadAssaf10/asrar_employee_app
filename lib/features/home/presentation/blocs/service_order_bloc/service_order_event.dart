part of 'service_order_bloc.dart';

abstract class ServiceOrderEvent extends Equatable {
  const ServiceOrderEvent();
}

class GetPendingOrders extends ServiceOrderEvent {
  @override
  List<Object?> get props => [];
}

class GetCurrentOrders extends ServiceOrderEvent {
  final Employee employee;

  const GetCurrentOrders({
    required this.employee,
  });

  @override
  List<Object> get props => [employee];
}

class GetOrdersArchive extends ServiceOrderEvent {
  final Employee employee;

  const GetOrdersArchive({
    required this.employee,
  });

  @override
  List<Object> get props => [employee];
}

class AcceptOrder extends ServiceOrderEvent {
  final BuildContext context;
  final Employee employee;
  final ServiceOrder serviceOrder;

  const AcceptOrder({
    required this.context,
    required this.employee,
    required this.serviceOrder,
  });

  @override
  List<Object?> get props => [employee, serviceOrder];
}

class CancelOrder extends ServiceOrderEvent {
  final ServiceOrder serviceOrder;

  const CancelOrder({
    required this.serviceOrder,
  });

  @override
  List<Object?> get props => [serviceOrder];
}

class CompleteOrder extends ServiceOrderEvent {
  final ServiceOrder serviceOrder;

  const CompleteOrder({
    required this.serviceOrder,
  });

  @override
  List<Object?> get props => [serviceOrder];
}
