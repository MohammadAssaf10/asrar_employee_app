part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class GetEmployeeNotifications extends NotificationEvent {
  final String employeeID;

  const GetEmployeeNotifications({required this.employeeID});

  @override
  List<Object?> get props => [employeeID];
}
