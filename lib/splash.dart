import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes_manager.dart';
import 'language_cubit/language_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.auth);
              },
              child: const Text('auth')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.signIn);
              },
              child: const Text('signIN')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.signUp);
              },
              child: const Text('signUp')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.homeRoute);
              },
              child: const Text('Home')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.passwordReset);
              },
              child: const Text('password reset')),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                  onPressed: () {
                    context.read<LanguageCubit>().setArabic();
                  },
                  child: const Text('ar')),
              ElevatedButton(
                  onPressed: () {
                    context.read<LanguageCubit>().setEnglish();
                  },
                  child: const Text('en')),
            ],
          )
        ],
      )),
    );
  }
}
