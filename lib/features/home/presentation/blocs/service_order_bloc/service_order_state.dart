part of 'service_order_bloc.dart';

enum Status { init, loading, success, failed }

class ServiceOrderState extends Equatable {
  final Status currentOrderStatus;
  final List<ServiceOrder> currentOrder;
  final Status archiveOrderStatus;
  final List<ServiceOrder> archiveOrder;
  final String? message;

  const ServiceOrderState._({
    required this.currentOrderStatus,
    required this.currentOrder,
    required this.archiveOrderStatus,
    required this.archiveOrder,
    this.message,
  });

  ServiceOrderState.init()
      : archiveOrder = [],
        currentOrder = [],
        archiveOrderStatus = Status.init,
        currentOrderStatus = Status.init,
        message = null;

  @override
  List<Object> get props {
    return [
      currentOrderStatus,
      currentOrder,
      archiveOrderStatus,
      archiveOrder,
    ];
  }

  ServiceOrderState copyWith({
    Status? currentOrderStatus,
    List<ServiceOrder>? currentOrder,
    Status? archiveOrderStatus,
    List<ServiceOrder>? archiveOrder,
    String? message,
  }) {
    return ServiceOrderState._(
      currentOrderStatus: currentOrderStatus ?? this.currentOrderStatus,
      currentOrder: currentOrder ?? this.currentOrder,
      archiveOrderStatus: archiveOrderStatus ?? this.archiveOrderStatus,
      archiveOrder: archiveOrder ?? this.archiveOrder,
      message: message ?? this.message,
    );
  }
}
