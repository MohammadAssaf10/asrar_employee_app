import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/color_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/app_localizations.dart';
import '../../../../config/values_manager.dart';
import '../../domain/entities/entities.dart';
import '../common/widgets.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final EmployeeImages _images = EmployeeImages();

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.s30.w, vertical: AppSize.s18.h),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSize.s20.h,
                ),
                const RegisterText(),
                SizedBox(
                  height: AppSize.s20.h,
                ),
                TextFrom(label: AppStrings.name.tr(context)),
                TextFrom(label: AppStrings.mobileNumber.tr(context)),
                TextFrom(label: AppStrings.email.tr(context)),
                TextFrom(label: AppStrings.idNumber.tr(context)),
                TextFrom(label: AppStrings.nationality.tr(context)),
                SizedBox(
                  height: 10.h,
                ),
                FileButton(
                  text: AppStrings.id.tr(context),
                  onChange: (v) {
                    _images.id = v;
                  },
                ),
                FileButton(
                  text: AppStrings.address.tr(context),
                  onChange: (v) {
                    _images.address = v;
                  },
                ),
                FileButton(
                  text: AppStrings.personalPhoto.tr(context),
                  onChange: (v) {
                    _images.personal = v;
                  },
                ),
                FileButton(
                  text: AppStrings.bankIBANCertificate.tr(context),
                  onChange: (v) {
                    _images.bankIBAN = v;
                  },
                ),
                FileButton(
                  text: AppStrings.commercialRegistryInstitutions.tr(context),
                  onChange: (v) {
                    _images.commercial = v;
                  },
                ),
                FileButton(
                  text: AppStrings.pictureOfTheHeadquarters.tr(context),
                  onChange: (v) {
                    _images.headquarters = v;
                  },
                ),
                SizedBox(
                  height: AppSize.s30.h,
                ),
                FullElevatedButton(
                    onPressed: () {},
                    text: AppStrings.registerNewAccount.tr(context)),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

class RegisterText extends StatelessWidget {
  const RegisterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.registerNow.tr(context),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ColorManager.white),
        ),
        Text(
          AppStrings.toRegisterWithUsPleaseFill.tr(context),
          style: const TextStyle(color: ColorManager.white),
        ),
      ],
    );
  }
}
