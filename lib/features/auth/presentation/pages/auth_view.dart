import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/color_manager.dart';
import '../../../../config/routes_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/app_localizations.dart';
import '../../../../config/values_manager.dart';
import '../common/widgets.dart';

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
              ColorManager.primary,
              Colors.white,
            ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const SizedBox(),
            SizedBox(
              width: 200,
              child: Text(
                AppStrings.helloText.tr(context),
                style: TextStyle(
                    fontSize: AppSize.s40.sp, color: ColorManager.white),
              ),
            ),
            const SizedBox(),
            Column(
              children: [
                FullElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.signIn);
                  },
                  text: AppStrings.signIn.tr(context),
                ),
                SizedBox(
                  height: AppSize.s30.h,
                ),
                FullElevatedButton(
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
