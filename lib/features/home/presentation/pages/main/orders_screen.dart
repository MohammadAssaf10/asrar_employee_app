import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../core/app/functions.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../blocs/service_order_bloc/service_order_bloc.dart';
import '../../widgets/general/empty_list_view.dart';
import '../../widgets/general/pending_order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
    var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (serviceOrderBloc.state.pendingOrderList.isEmpty && authBlocState is AuthenticationSuccess) {
      serviceOrderBloc.add(GetPendingOrders());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.orders.tr(context)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
          var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
          if (authBlocState is AuthenticationSuccess) {
            serviceOrderBloc.add(GetPendingOrders());
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocConsumer<ServiceOrderBloc, ServiceOrderState>(
            listener: (context, state) {
              if (state.pendingOrderStatus == Status.loading) {
                showCustomDialog(context);
              } else if (state.pendingOrderStatus == Status.failed) {
                showCustomDialog(context, message: state.message);
              } else if (state.processStatus == Status.loading) {
                showCustomDialog(context);
              } else if (state.processStatus == Status.failed) {
                showCustomDialog(context, message: state.message);
              } else {
                dismissDialog(context);
              }
            },
            builder: (context, state) {
              if (state.pendingOrderList.isEmpty) {
                return EmptyListView(
                  emptyListMessage:
                      '${AppStrings.noOrders.tr(context)}: \n${AppStrings.toGetNewOrdersGoToOrderView.tr(context)}',
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width,
                );
              }
              return ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.pendingOrderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return PendingOrderCard(
                    order: state.pendingOrderList[index],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
