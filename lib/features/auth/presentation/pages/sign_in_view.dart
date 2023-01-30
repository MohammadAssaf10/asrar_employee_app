
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/color_manager.dart';
import '../bloc/authentication_bloc.dart';
import '../functions.dart';
import '../widgets/login_form.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
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
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
