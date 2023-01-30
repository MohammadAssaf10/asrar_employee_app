import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/app/di.dart' as di;
import '../../../../core/app/extensions.dart';
import '../../../../core/data/repo/storage_file_repository_impl.dart';
import '../../data/data_sources/auth_prefs.dart';
import '../../data/models/requests.dart';
import '../../domain/entities/employee.dart';
import '../../domain/entities/permissions.dart';
import '../../domain/repository/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository = di.instance<AuthRepository>();
  final AuthPreferences _authPreferences = di.instance<AuthPreferences>();
  final StorageFileRepository _fileRepository = StorageFileRepository();

  static AuthenticationBloc instance = AuthenticationBloc._();

  AuthenticationBloc._() : super(AuthenticationInitial()) {
    // login
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthenticationInProgress());

      (await _authRepository.login(event.loginRequest)).fold(
        (failure) {
          emit(AuthenticationFailed(failure.message));
        },
        (employee) {
          emit(AuthenticationSuccess(employee: employee));
          _authPreferences.setPermission(employee.permissions);
        },
      );
    });

    // register
    on<RegisterButtonPressed>((event, emit) async {
      emit(AuthenticationInProgress());

      await (await _authRepository.register(event.registerRequest)).fold(
          (failure) {
        emit(AuthenticationFailed(failure.message));
      }, (employee) async {
        bool success = true;

        final List<UploadFileParams> uploads = _getUploadingFileList(event);

        for (int i = 0; i < uploads.length; i++) {
          if (!success) return;

          emit(UploadingImages(message: "$i/${uploads.length}"));

          await (await _fileRepository.uploadFile(
                  uploads[i].file, uploads[i].fileName))
              .fold(((failure) async {
            emit(AuthenticationFailed(failure.message));
            _authRepository.deleteEmployee(employee.email);
            success = false;
          }), ((_) {}));
        }

        if (success) {
          emit(AuthenticationSuccess(employee: employee));
          _authPreferences.setPermission(employee.permissions);
        }
      });
    });

    on<SendVerificationCodeButtonPressed>((event, emit) async {
      emit(AuthenticationInProgress());
      (await _authRepository.resetPassword(event.email)).fold((failure) {
        emit(AuthenticationFailed(failure.message));
      }, (_) {
        emit(ResetPasswordRequestSuccess());
      });
    });

    on<AppStarted>((event, emit) async {
      (await _authRepository.getCurrentUserIfExists()).fold(((l) {}),
          ((employee) async {
        if (employee != null) {
          emit(AuthenticationSuccess(employee: employee));
          await _authPreferences.setPermission(employee.permissions);
        }
      }));
    });

    on<LogOut>((event, emit) async {
      await _authRepository.logout();
      // tuned all permission to false
      await _authPreferences.setPermission(Permissions.fromMap({}));
      emit(AuthenticationInitial());
    });
  }
}

class UploadFileParams {
  File file;
  String fileName;

  UploadFileParams(this.file, this.fileName);
}

_getUploadingFileList(RegisterButtonPressed event) {
  const employees = 'employees';
  final String thisEmployeePath = event.registerRequest.email;
  return [
    // id image
    UploadFileParams(event.registerRequest.id,
        '$employees/$thisEmployeePath/id.${event.registerRequest.id.getExtension()}'),
    // address image
    UploadFileParams(event.registerRequest.address,
        '$employees/$thisEmployeePath/address.${event.registerRequest.address.getExtension()}'),
    // bank IBAN image
    UploadFileParams(event.registerRequest.bankIBAN,
        '$employees/$thisEmployeePath/bankIBAN.${event.registerRequest.bankIBAN.getExtension()}'),
    // commercial image
    UploadFileParams(event.registerRequest.commercial,
        '$employees/$thisEmployeePath/commercial.${event.registerRequest.commercial.getExtension()}'),
    // headquarters image
    UploadFileParams(event.registerRequest.headquarters,
        '$employees/$thisEmployeePath/headquarters.${event.registerRequest.headquarters.getExtension()}'),
    // personal image
    UploadFileParams(event.registerRequest.personal,
        '$employees/$thisEmployeePath/personal.${event.registerRequest.personal.getExtension()}')
  ];
}
