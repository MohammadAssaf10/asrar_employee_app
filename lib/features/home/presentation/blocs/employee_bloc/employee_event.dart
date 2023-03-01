part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
}

class GetEmployeeInfo extends EmployeeEvent {
  final String id;

  const GetEmployeeInfo({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateEmployeeImageEvent extends EmployeeEvent {
  final EmployeeUpdatesRequest employeeUpdates;
  final XFile xFile;

  const UpdateEmployeeImageEvent(
      {required this.employeeUpdates, required this.xFile});

  @override
  List<Object?> get props => [employeeUpdates, xFile];
}

class UpdatePasswordEvent extends EmployeeEvent {
  final String newPassword;

  const UpdatePasswordEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class UpdateEmployeeInfo extends EmployeeEvent {
  final EmployeeUpdatesRequest employeeUpdates;
  final String newEmail;

  const UpdateEmployeeInfo({
    required this.employeeUpdates,
    required this.newEmail,
  });

  @override
  List<Object?> get props => [employeeUpdates, newEmail];
}
