part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();
}

class EmployeeInitial extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class EmployeeLoadingState extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class EmployeeErrorState extends EmployeeState {
  final String errorMessage;
  const EmployeeErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

class EmployeeLoadedState extends EmployeeState {
  final Employee employee;
  const EmployeeLoadedState({required this.employee});
  @override
  List<Object?> get props => [employee];
}

class ImageUpdatedSuccessfullyState extends EmployeeState {
  @override
  List<Object?> get props => [];
}
class EmployeeInfoUpdatedSuccessfullyState extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class PasswordUpdatedLoadingState extends EmployeeState {
  @override
  List<Object?> get props => [];
}
class PasswordUpdatedSuccessfullyState extends EmployeeState {
  @override
  List<Object?> get props => [];
}

class PasswordUpdatedErrorState extends EmployeeState {
  final String errorMessage;
  const PasswordUpdatedErrorState({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
