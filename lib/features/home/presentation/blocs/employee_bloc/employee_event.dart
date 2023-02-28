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
  final Employee employee;
  final XFile image;
  const UpdateEmployeeImageEvent({required this.employee, required this.image});
  @override
  List<Object?> get props => [employee, image];
}

class UpdatePasswordEvent extends EmployeeEvent {
  final String newPassword;
  const UpdatePasswordEvent({required this.newPassword});
  @override
  List<Object?> get props => [newPassword];
}

class UpdateEmployeeInfo extends EmployeeEvent {
  final Employee oldEmployee;
  final String newEmail;
  final String newName;
  final String newPhoneNumber;
  const UpdateEmployeeInfo(
      {required this.oldEmployee,
      required this.newEmail,
      required this.newName,
      required this.newPhoneNumber});
  @override
  List<Object?> get props => [oldEmployee, newEmail, newName, newPhoneNumber];
}
