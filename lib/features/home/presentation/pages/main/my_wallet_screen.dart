import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../blocs/my_wallet_bloc/my_wallet_bloc.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key? key}) : super(key: key);

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  @override
  void initState() {
    super.initState();

    var authState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (authState is AuthenticationSuccess) {
      var employee = authState.employee;
      BlocProvider.of<MyWalletBloc>(context).add(GetData(employee: employee));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.myWallet.tr(context)),
      ),
      body: Center(
        child: BlocBuilder<MyWalletBloc, MyWalletState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${AppStrings.appFee.tr(context)}: ${state.myWallet.appNet}%",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${AppStrings.myEntitlements.tr(context)} : ${state.myWallet.amount}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
