import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/routes_manager.dart';
import 'features/auth/presentation/bloc/authentication_bloc.dart';
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
            child: const Text('auth'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.homeRoute);
            },
            child: const Text('Home'),
          ),ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LogOut());
            },
            child: const Text('logOut'),
          ),
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
