part of 'my_wallet_bloc.dart';

abstract class MyWalletEvent extends Equatable {
  const MyWalletEvent();
}

class GetData extends MyWalletEvent {
  final Employee employee;

  const GetData({
    required this.employee,
  });

  @override
  List<Object?> get props => [employee];
}
