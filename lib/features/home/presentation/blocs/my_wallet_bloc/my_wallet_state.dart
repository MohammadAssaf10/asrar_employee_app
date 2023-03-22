part of 'my_wallet_bloc.dart';

class MyWalletState extends Equatable {
  final MyWallet myWallet;

  const MyWalletState({required this.myWallet});
  MyWalletState.init() : myWallet = MyWallet.fromMap({});

  @override
  List<Object> get props => [];

  MyWalletState copyWith({
    MyWallet? myWallet,
  }) {
    return MyWalletState(
      myWallet: myWallet ?? this.myWallet,
    );
  }
}
