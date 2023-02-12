import 'package:flutter/material.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/strings_manager.dart';
import '../../widgets/general/switcher_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.orders.tr(context)),
      ),
      body: ListView(
        children: [
          SwitcherWidget(
            onChange: (v) {
              setState(() {
                isFirst = v;
              });
            },
          ),
          AnimatedCrossFade(
            alignment: Alignment.center,
            firstChild: Container(),
            secondChild: Container(),
            crossFadeState: isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}
