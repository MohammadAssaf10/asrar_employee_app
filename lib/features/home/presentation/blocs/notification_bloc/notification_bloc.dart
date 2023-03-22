import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/app/di.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/repositories/notification_repository.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository =
      instance<NotificationRepository>();

  NotificationBloc() : super(const NotificationState()) {
    on<GetEmployeeNotifications>((event, emit) async {
      emit(state.copyWith(notificationStatus: NotificationStatus.loading));
      (await _notificationRepository.getUserNotifications(event.employeeID)).fold(
          (failure) {
        emit(state.copyWith(
          notificationStatus: NotificationStatus.error,
          errorMessage: failure.message,
        ));
      }, (notificationList) {
        emit(state.copyWith(
            notificationStatus: NotificationStatus.success,
            notificationList: notificationList));
      });
    });
  }
}
