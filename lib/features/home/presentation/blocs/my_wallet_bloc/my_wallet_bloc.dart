import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../auth/domain/entities/employee.dart';
import '../../../data/repositories/my_wallet_repository.dart';
import '../../../domain/entities/my_wallet.dart';

part 'my_wallet_event.dart';
part 'my_wallet_state.dart';

class MyWalletBloc extends Bloc<MyWalletEvent, MyWalletState> {
  final MyWalletRepository _myWalletRepository = MyWalletRepository();

  MyWalletBloc() : super(MyWalletState.init()) {
    on<GetData>((event, emit) async {
      (await _myWalletRepository.getData(event.employee)).fold(
        (l) {},
        (r) {
          emit(state.copyWith(myWallet: r));
        },
      );
    });
  }
}
