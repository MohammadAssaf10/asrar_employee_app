import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/color_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/app_localizations.dart';
import '../../../../config/values_manager.dart';
import '../../../../core/app/functions.dart';
import '../../data/models/requests.dart';
import '../../domain/entities/entities.dart';
import '../bloc/authentication_bloc.dart';
import '../functions.dart';
import '../widgets/register_form.dart';
import '../widgets/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  EmployeeTextFields _textFields = EmployeeTextFields();
  EmployeeImages _images = EmployeeImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          manageDialog(context, state);
        },
        child: Container(
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
                  SizedBox(height: AppSize.s20.h),
                  RegisterTextForms(
                    onChange: (v) {
                      _textFields = v;
                    },
                  ),
                  SizedBox(height: 10.h),
                  RegisterImagesFields(
                    onChange: (v) {
                      _images = v;
                    },
                  ),
                  FullElevatedButton(
                      onPressed: () {
                        if (!_textFields.isAllFieldsFiled()) {
                          showCustomDialog(context,
                              message: AppStrings.enterAllFields.tr(context));
                        } else if (!_images.isAllFieldsFiled()) {
                          showCustomDialog(context,
                              message: AppStrings.enterAllImages.tr(context));
                        }
                        BlocProvider.of<AuthenticationBloc>(context).add(
                            RegisterButtonPressed(RegisterRequest.fromObject(
                                _textFields, _images)));
                      },
                      text: AppStrings.registerNewAccount.tr(context)),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
