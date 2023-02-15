import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../core/app/functions.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../blocs/service_order_bloc/service_order_bloc.dart';
import '../../widgets/general/drawer.dart';
import '../../widgets/general/empty_list_view.dart';
import '../../widgets/general/order_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
    var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (serviceOrderBloc.state.currentOrderList.isEmpty && authBlocState is AuthenticationSuccess) {
      serviceOrderBloc.add(GetCurrentOrders(employee: authBlocState.employee));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(
          AppStrings.asrarForElectronicServices.tr(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: navigate to notification view
            },
            icon: SvgPicture.asset(IconAssets.notification),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
          var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
          if (authBlocState is AuthenticationSuccess) {
            serviceOrderBloc.add(GetCurrentOrders(employee: authBlocState.employee));
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocConsumer<ServiceOrderBloc, ServiceOrderState>(
            listener: (context, state) {
              if (state.currentOrderStatus == Status.loading) {
                showCustomDialog(context);
              } else if (state.currentOrderStatus == Status.failed) {
                showCustomDialog(context, message: state.message);
              } else {
                dismissDialog(context);
              }
            },
            builder: (context, state) {
              if (state.currentOrderList.isEmpty) {
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
                itemCount: state.currentOrderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return OrderCard(
                    order: state.currentOrderList[index],
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
