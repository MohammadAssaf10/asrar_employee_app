import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../widgets/general/drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
            onPressed: () {},
            icon: SvgPicture.asset(IconAssets.notification),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(IconAssets.share),
          // ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: AppSize.s10.h),
          SizedBox(height: AppSize.s10.h),
        ],
      ),
    );
  }
}
