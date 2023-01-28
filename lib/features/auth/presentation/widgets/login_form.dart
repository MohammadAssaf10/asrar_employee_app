import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/app_localizations.dart';
import '../../../../config/color_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/values_manager.dart';
import '../../../../core/app/functions.dart';
import '../../data/models/requests.dart';
import '../bloc/authentication_bloc.dart';
import 'widgets.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  bool validateEmail = false;
  bool validatePassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 8.h),
      child: Column(
        children: [
          SizedBox(
            height: AppSize.s150.h,
          ),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFrom(
                  controller: _emailTextEditingController,
                  icon: Icons.email_outlined,
                  label: AppStrings.email.tr(context),
                  onTap: () {
                    setState(() {
                      validateEmail = true;
                    });
                  },
                  validator: (v) => cantBeEmpty(v, context),
                ),
                SizedBox(height: AppSize.s15.h),
                TextFrom(
                  onTap: () {
                    setState(() {
                      validatePassword = true;
                    });
                  },
                  controller: _passwordTextEditingController,
                  icon: Icons.lock_outline,
                  label: AppStrings.password.tr(context),
                  validator: (v) => cantBeEmpty(v, context),
                ),
                TextButton(
                  child: Text(
                    AppStrings.forgetYourPassword.tr(context),
                    style: const TextStyle(color: ColorManager.grey),
                  ),
                  onPressed: () {
                    // TODO: navigate to reset password
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: AppSize.s100.h,
          ),
          FullElevatedButton(
            onPressed: () {
              setState(() {
                validateEmail = true;
                validatePassword = true;
              });
              if (_key.currentState!.validate()) {
                BlocProvider.of<AuthenticationBloc>(context).add(
                    LoginButtonPressed(LoginRequest(
                        _emailTextEditingController.text,
                        _passwordTextEditingController.text)));
              }
            },
            text: AppStrings.signIn.tr(context),
          ),
          SizedBox(
            height: AppSize.s1000.h,
          ),
        ],
      ),
    );
  }
}
