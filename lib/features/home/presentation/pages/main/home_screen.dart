import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/assets_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../widgets/general/drawer.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isFirst = true;

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
        ],
      ),
      body: Column(),
    );
  }
}
