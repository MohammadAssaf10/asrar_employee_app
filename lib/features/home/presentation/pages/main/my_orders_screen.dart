import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/routes_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../core/app/constants.dart';
import '../../../../../core/app/functions.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../blocs/notification_bloc/notification_bloc.dart';
import '../../blocs/service_order_bloc/service_order_bloc.dart';
import '../../widgets/general/drawer.dart';
import '../../widgets/general/empty_list_view.dart';
import '../../widgets/general/order_card.dart';
import '../../widgets/general/switcher_widget.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: Text(
          AppStrings.myOrders.tr(context),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final state = BlocProvider.of<AuthenticationBloc>(context).state;
              if (state is AuthenticationSuccess) {
                BlocProvider.of<NotificationBloc>(context).add(
                    GetEmployeeNotifications(
                        employeeID: state.employee.employeeID));
                Navigator.pushNamed(context, Routes.notificationRoute);
              }
            },
            icon: SvgPicture.asset(IconAssets.notification),
          ),
        ],
      ),
      body: ListView(
        children: [
          SwitcherWidget(
            firstButtonLabel: AppStrings.currentOrder.tr(context),
            secondButtonLabel: AppStrings.archiveOrder.tr(context),
            onChange: (v) {
              setState(() {
                isFirst = v;
              });
            },
          ),
          AnimatedCrossFade(
            alignment: Alignment.center,
            firstChild: const CurrentOrders(),
            secondChild: const ArchiveOrders(),
            crossFadeState:
                isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class CurrentOrders extends StatefulWidget {
  const CurrentOrders({
    Key? key,
  }) : super(key: key);

  @override
  State<CurrentOrders> createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  @override
  void initState() {
    super.initState();
    var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
    var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (serviceOrderBloc.state.currentOrderList.isEmpty &&
        authBlocState is AuthenticationSuccess) {
      serviceOrderBloc.add(GetCurrentOrders(employee: authBlocState.employee));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
        var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
        if (authBlocState is AuthenticationSuccess) {
          serviceOrderBloc
              .add(GetCurrentOrders(employee: authBlocState.employee));
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocConsumer<ServiceOrderBloc, ServiceOrderState>(
          listenWhen: (previous, current) {
            return previous.currentOrderStatus != current.currentOrderStatus;
          },
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
    );
  }
}

class ArchiveOrders extends StatefulWidget {
  const ArchiveOrders({
    Key? key,
  }) : super(key: key);

  @override
  State<ArchiveOrders> createState() => _ArchiveOrdersState();
}

class _ArchiveOrdersState extends State<ArchiveOrders> {
  @override
  void initState() {
    super.initState();
    var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
    var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (serviceOrderBloc.state.archiveOrderList.isEmpty &&
        authBlocState is AuthenticationSuccess) {
      serviceOrderBloc.add(GetOrdersArchive(employee: authBlocState.employee));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        var serviceOrderBloc = BlocProvider.of<ServiceOrderBloc>(context);
        var authBlocState = BlocProvider.of<AuthenticationBloc>(context).state;
        if (authBlocState is AuthenticationSuccess) {
          serviceOrderBloc
              .add(GetOrdersArchive(employee: authBlocState.employee));
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocConsumer<ServiceOrderBloc, ServiceOrderState>(
          listenWhen: (previous, current) {
            return previous.archiveOrderStatus != current.archiveOrderStatus;
          },
          listener: (context, state) {
            if (state.archiveOrderStatus == Status.loading) {
              showCustomDialog(context);
            } else if (state.archiveOrderStatus == Status.failed) {
              showCustomDialog(context, message: state.message);
            } else {
              dismissDialog(context);
            }
          },
          builder: (context, state) {
            if (state.archiveOrderList.isEmpty) {
              return EmptyListView(
                emptyListMessage: AppStrings.noOrders.tr(context),
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
              );
            }
            return ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.archiveOrderList.length,
              itemBuilder: (BuildContext context, int index) {
                return OrderCard(
                  order: state.archiveOrderList[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
