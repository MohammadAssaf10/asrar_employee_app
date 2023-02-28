import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/app/di.dart';
import '../../../../auth/data/data_sources/firebase_auth_helper.dart';
import '../../../../auth/domain/entities/employee.dart';
import '../../../domain/repositories/employee_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final FirebaseAuthHelper _authHelper = instance<FirebaseAuthHelper>();
  final EmployeeRepository employeeRepository = instance<EmployeeRepository>();
  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetEmployeeInfo>((event, emit) async {
      emit(EmployeeLoadingState());
      try {
        final employee = await _authHelper.getEmployee(event.id);
        emit(EmployeeLoadedState(employee: employee));
      } catch (e) {
        emit(EmployeeErrorState(errorMessage: e.toString()));
      }
    });
    on<UpdateEmployeeImageEvent>((event, emit) async {
      emit(EmployeeLoadingState());
      (await employeeRepository.updateEmployeeImage(event.image, event.employee)).fold(
          (failure) {
        emit(EmployeeErrorState(errorMessage: failure.message));
      }, (r) {
        emit(ImageUpdatedSuccessfullyState());
      });
    });
    on<UpdatePasswordEvent>((event, emit) async {
      emit(PasswordUpdatedLoadingState());
      (await employeeRepository.updatePassword(event.newPassword)).fold((failure) {
        emit(PasswordUpdatedErrorState(errorMessage: failure.message));
      }, (r) {
        emit(PasswordUpdatedSuccessfullyState());
      });
    });
    on<UpdateEmployeeInfo>((event, emit) async {
      emit(EmployeeLoadingState());
      (await employeeRepository.updateEmployeeInfo(event.oldEmployee, event.newEmail,
              event.newName, event.newPhoneNumber))
          .fold((failure) {
        emit(EmployeeErrorState(errorMessage: failure.message));
      }, (r) {
        emit(EmployeeInfoUpdatedSuccessfullyState());
      });
    });
  }
}
