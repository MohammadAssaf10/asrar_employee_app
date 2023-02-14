import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../auth/domain/entities/employee.dart';
import '../../../domain/entities/service_order.dart';

part 'service_order_event.dart';
part 'service_order_state.dart';

class ServiceOrderBloc extends Bloc<ServiceOrderEvent, ServiceOrderState> {
  ServiceOrderBloc() : super(ServiceOrderState.init()) {
    on<GetCurrentOrders>((event, emit) {});

    on<GetOrdersArchive>((event, emit) {});

    on<AcceptOrder>((event, emit) {});

    on<CancelOrder>((event, emit) {});

    on<FinishOrder>((event, emit) {});
  }
}
