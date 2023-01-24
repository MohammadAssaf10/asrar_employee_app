
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/app/di.dart';
import '../../../../core/app/extensions.dart';
import '../../../../core/data/repo/storage_file_repository_impl.dart';
import '../../data/data_sources/auth_prefs.dart';
import '../../data/models/requests.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repository/repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository = instance<AuthRepository>();
  final AuthPreferences _authPreferences = instance<AuthPreferences>();
  final StorageFileRepository _fileRepository = StorageFileRepository();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    // login
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthenticationInProgress());
      (await _authRepository.login(event.loginRequest)).fold((failure) {
        emit(AuthenticationFailed(failure.message));
      }, (employee) {
        emit(AuthenticationSuccess(employee: employee));
        _authPreferences.setUserLoggedIn();
      });
    });

    // register
    on<RegisterButtonPressed>((event, emit) async {
      emit(AuthenticationInProgress());

      await (await _authRepository.register(event.registerRequest)).fold(
          (failure) {
        emit(AuthenticationFailed(failure.message));
      }, (employee) async {
        const employees = 'employees';
        final String thisEmployeePath = event.registerRequest.email;

        emit(UploadingImages(message: "0/6"));

        (await _fileRepository.uploadFile(event.registerRequest.id,
                '$employees/$thisEmployeePath/id.${event.registerRequest.id.getExtension()}'))
            .fold((l) {
          emit(AuthenticationFailed(l.message));
        }, (r) {
          emit(UploadingImages(message: "1/6"));
        });

        (await _fileRepository.uploadFile(event.registerRequest.address,
                '$employees/$thisEmployeePath/address.${event.registerRequest.address.getExtension()}'))
            .fold(((l) {
          emit(AuthenticationFailed(l.message));
        }), ((r) {
          emit(UploadingImages(message: "2/6"));
        }));

        (await _fileRepository.uploadFile(event.registerRequest.bankIBAN,
                '$employees/$thisEmployeePath/bankIBAN.${event.registerRequest.bankIBAN.getExtension()}'))
            .fold(((l) {
          emit(AuthenticationFailed(l.message));
        }), ((r) {
          emit(UploadingImages(message: "3/6"));
        }));

        (await _fileRepository.uploadFile(event.registerRequest.commercial,
                '$employees/$thisEmployeePath/commercial.${event.registerRequest.commercial.getExtension()}'))
            .fold(((l) {
          emit(AuthenticationFailed(l.message));
        }), ((r) {
          emit(UploadingImages(message: "4/6"));
        }));

        (await _fileRepository.uploadFile(event.registerRequest.headquarters,
                '$employees/$thisEmployeePath/headquarters.${event.registerRequest.headquarters.getExtension()}'))
            .fold(((l) {
          emit(AuthenticationFailed(l.message));
        }), ((r) {
          emit(UploadingImages(message: "5/6"));
        }));

        (await _fileRepository.uploadFile(event.registerRequest.personal,
                '$employees/$thisEmployeePath/personal.${event.registerRequest.personal.getExtension()}'))
            .fold(((l) {
          emit(AuthenticationFailed(l.message));
        }), ((r) {
          emit(UploadingImages(message: "6/6"));
        }));

        emit(AuthenticationSuccess(employee: employee));

        _authPreferences.setUserLoggedIn();
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

    on<AppStarted>(
      (event, emit) {},
    );
  }
}
