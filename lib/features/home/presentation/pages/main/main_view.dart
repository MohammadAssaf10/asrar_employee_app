import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/color_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../blocs/employee_bloc/employee_bloc.dart';
import '../../widgets/general/navigation_bar_bottom.dart';
import 'customers_service_screen.dart';
import 'my_orders_screen.dart';
import 'my_wallet_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 2);
    return Stack(
      children: [
        Scaffold(
          body: PageView(
            onPageChanged: (v) {
              final authState = BlocProvider.of<AuthenticationBloc>(context).state;
              if (v == 4 && authState is AuthenticationSuccess) {
                BlocProvider.of<EmployeeBloc>(context)
                    .add(GetEmployeeInfo(id: authState.employee.employeeID));
              }
            },
            controller: controller,
            children: const [
              OrdersScreen(),
              MyWalletScreen(),
              MyOrdersScreen(),
              CustomersServiceScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            height: AppSize.s50.h,
            color: ColorManager.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationBarBottom(
                      title: AppStrings.orders.tr(context),
                      icon: IconAssets.orders,
                      onPress: () {
                        controller.jumpToPage(0);
                      },
                    ),
                    NavigationBarBottom(
                      title: AppStrings.myWallet.tr(context),
                      icon: IconAssets.wallet,
                      onPress: () => controller.jumpToPage(1),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NavigationBarBottom(
                      title: AppStrings.customerService.tr(context),
                      icon: IconAssets.customersService,
                      onPress: () => controller.jumpToPage(3),
                    ),
                    NavigationBarBottom(
                      title: AppStrings.profile.tr(context),
                      icon: IconAssets.profile,
                      onPress: () => controller.jumpToPage(4),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Center(
            child: GestureDetector(
              onTap: () {
                controller.jumpToPage(2);
              },
              child: Image.asset(
                IconAssets.home,
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
