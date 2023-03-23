import 'package:asrar_employee_app/config/app_localizations.dart';
import 'package:asrar_employee_app/config/strings_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/app/constants.dart';
import '../../../../../core/app/di.dart';
import '../../../../auth/data/data_sources/auth_prefs.dart';
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

    on<GetOrdersArchive>((event, emit) async {
      emit(state.copyWith(archiveOrderStatus: Status.loading));
      (await _serviceOrderRepository.getEmployeeArchiveOrder(event.employee)).fold(
        (l) {
          emit(state.copyWith(archiveOrderStatus: Status.failed, message: l.message));
        },
        (r) {
          emit(state.copyWith(archiveOrderStatus: Status.success, archiveOrder: r));
        },
      );
    });

    on<AcceptOrder>((event, emit) async {
      emit(state.copyWith(processStatus: Status.loading));
      if (!instance<AuthPreferences>().canWork()) {
        emit(state.copyWith(
            processStatus: Status.failed,
            message: AppStrings.dontHavePermission.tr(event.context)));
      }

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

    on<CancelOrder>((event, emit) async {
      emit(state.copyWith(processStatus: Status.loading));

      (await _serviceOrderRepository.cancelOrder(event.serviceOrder)).fold(
        (l) {
          emit(state.copyWith(processStatus: Status.failed, message: l.message));
        },
        (r) {
          var currentOrderList = state.currentOrderList;

          currentOrderList.remove(event.serviceOrder);

          currentOrderList.sort((a, b) => (a.id < b.id) ? 1 : 0);

          emit(state.copyWith(
            processStatus: Status.success,
            currentOrder: currentOrderList,
          ));
        },
      );
    });

    on<CompleteOrder>((event, emit) async {
      emit(state.copyWith(processStatus: Status.loading));

      (await _serviceOrderRepository.finishOrder(event.serviceOrder)).fold(
        (l) {
          emit(state.copyWith(processStatus: Status.failed, message: l.message));
        },
        (r) {
          var currentOrderList = state.currentOrderList;
          var archiveOrderList = state.archiveOrderList;
          currentOrderList.remove(event.serviceOrder);
          archiveOrderList.add(event.serviceOrder.copyWith(status: OrderStatus.completed.name));
          currentOrderList.sort((a, b) => (a.id < b.id) ? 1 : 0);
          archiveOrderList.sort((a, b) => (a.id < b.id) ? 1 : 0);
          emit(state.copyWith(
              processStatus: Status.success,
              currentOrder: currentOrderList,
              archiveOrder: archiveOrderList));
        },
      );
    });
  }
}
