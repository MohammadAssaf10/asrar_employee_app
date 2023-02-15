import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/app/di.dart';
import '../../../../auth/domain/entities/employee.dart';
import '../../../domain/entities/service_order.dart';
import '../../../domain/repositories/service_order_repository.dart';

part 'service_order_event.dart';
part 'service_order_state.dart';

class ServiceOrderBloc extends Bloc<ServiceOrderEvent, ServiceOrderState> {
  final ServiceOrderRepository _serviceOrderRepository = instance();

  ServiceOrderBloc() : super(ServiceOrderState.init()) {
    on<GetPendingOrders>((event, emit) async {
      emit(state.copyWith(pendingOrderStatus: Status.loading));
      (await _serviceOrderRepository.getPendingOrders()).fold(
        (l) {
          emit(state.copyWith(pendingOrderStatus: Status.failed, message: l.message));
        },
        (r) {
          r.sort(
            (a, b) {
              return a.id > b.id ? 1 : 0;
            },
          );
          emit(state.copyWith(pendingOrderStatus: Status.success, pendingOrder: r));
        },
      );
    });

    on<GetCurrentOrders>((event, emit) async {
      emit(state.copyWith(currentOrderStatus: Status.loading));
      (await _serviceOrderRepository.getEmployeeCurrentOrders(event.employee)).fold(
        (l) {
          emit(state.copyWith(currentOrderStatus: Status.failed, message: l.message));
        },
        (r) {
          emit(state.copyWith(currentOrderStatus: Status.success, currentOrder: r));
        },
      );
    });

    on<GetOrdersArchive>((event, emit) async {});

    on<AcceptOrder>((event, emit) async {
      emit(state.copyWith(processStatus: Status.loading));
      (await _serviceOrderRepository.acceptOrder(event.employee, event.serviceOrder)).fold(
        (l) {
          emit(state.copyWith(processStatus: Status.failed, message: l.message));
        },
        (r) {
          add(GetCurrentOrders(employee: event.employee));
          var newList = state.pendingOrderList..remove(event.serviceOrder);
          emit(state.copyWith(processStatus: Status.success, pendingOrder: newList));
        },
      );
    });

    on<CancelOrder>((event, emit) {});

    on<FinishOrder>((event, emit) {});
  }
}
