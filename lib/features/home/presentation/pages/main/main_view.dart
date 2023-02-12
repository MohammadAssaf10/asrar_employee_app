import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../widgets/general/navigation_bar_bottom.dart';
import 'customers_service_screen.dart';
import 'home_screen.dart';
import 'my_wallet_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 2);
    return Scaffold(
      body: PageView(
        controller: controller,
        children: const [
          OrdersScreen(),
          MyWalletScreen(),
          HomeScreen(),
          CustomersServiceScreen(),
          ProfileScreen(),
        ],
      ),
      floatingActionButton: MaterialButton(
        onPressed: () => controller.jumpToPage(2),
        child: Image.asset(
          IconAssets.home,
          filterQuality: FilterQuality.high,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: AppSize.s50.h,
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
                      // final state = BlocProvider.of<AuthenticationBloc>(context).state;
                      // BlocProvider.of<ShopOrderBloc>(context).add(
                      //   GetShopOrderEvent(
                      //     userEmail: state.user!.email,
                      //   ),
                      // );
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
    );
  }
}
