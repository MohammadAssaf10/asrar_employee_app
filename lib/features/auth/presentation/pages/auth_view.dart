import 'package:asrar_employee_app/config/assets_manager.dart';
import 'package:asrar_employee_app/config/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/routes_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/app_localizations.dart';
import '../../../../config/values_manager.dart';
import '../widgets/widgets.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
            center: Alignment.center,
            focal: Alignment.topCenter,
            radius: 4,
            colors: [
              ColorManager.veryDarkPrimary,
              ColorManager.primary,
              ColorManager.white,
            ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const SizedBox(),
            Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                child: Image.asset(ImageAssets.logo)),
            const SizedBox(),
            Column(
              children: [
                FullElevatedButton(
                  color: ColorManager.darkPrimary,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.signIn);
                  },
                  text: AppStrings.signIn.tr(context),
                ),
                SizedBox(
                  height: AppSize.s30.h,
                ),
                FullElevatedButton(
                  color: ColorManager.darkPrimary,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.signUp);
                  },
                  text: AppStrings.signUp.tr(context),
                )
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    ));
  }
}
