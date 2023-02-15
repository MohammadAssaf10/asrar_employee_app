part of 'service_order_bloc.dart';

enum Status { init, loading, success, failed }

// * when regenerate data class:
// - in [copyWith] remove the ?? in the message
class ServiceOrderState extends Equatable {
  final Status currentOrderStatus;
  final List<ServiceOrder> currentOrderList;
  final Status archiveOrderStatus;
  final List<ServiceOrder> archiveOrderList;
  final Status pendingOrderStatus;
  final List<ServiceOrder> pendingOrderList;
  final Status processStatus;
  final String? message;

  const ServiceOrderState._({
    required this.currentOrderStatus,
    required this.currentOrderList,
    required this.archiveOrderStatus,
    required this.archiveOrderList,
    required this.pendingOrderStatus,
    required this.pendingOrderList,
    required this.processStatus,
    this.message,
  });

  ServiceOrderState.init()
      : archiveOrderList = [],
        currentOrderList = [],
        pendingOrderList = [],
        archiveOrderStatus = Status.init,
        currentOrderStatus = Status.init,
        pendingOrderStatus = Status.init,
        processStatus = Status.init,
        message = null;

  @override
  List<Object> get props {
    return [
      currentOrderStatus,
      archiveOrderStatus,
      pendingOrderStatus,
      processStatus,
      currentOrderList,
      archiveOrderList,
      pendingOrderList,
    ];
  }

  ServiceOrderState copyWith({
    Status? currentOrderStatus,
    List<ServiceOrder>? currentOrder,
    Status? archiveOrderStatus,
    List<ServiceOrder>? archiveOrder,
    Status? pendingOrderStatus,
    List<ServiceOrder>? pendingOrder,
    Status? processStatus,
    String? message,
  }) {
    return ServiceOrderState._(
      currentOrderStatus: currentOrderStatus ?? this.currentOrderStatus,
      currentOrderList: currentOrder ?? currentOrderList,
      archiveOrderStatus: archiveOrderStatus ?? this.archiveOrderStatus,
      archiveOrderList: archiveOrder ?? archiveOrderList,
      pendingOrderStatus: pendingOrderStatus ?? this.pendingOrderStatus,
      pendingOrderList: pendingOrder ?? pendingOrderList,
      processStatus: processStatus ?? this.processStatus,
      message: message,
    );
  }
}
