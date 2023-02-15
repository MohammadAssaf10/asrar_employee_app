import 'package:flutter/material.dart';

import '../../../../../config/color_manager.dart';
import '../../../domain/entities/service_order.dart';

class AcceptButton extends StatelessWidget {
  const AcceptButton({
    Key? key,
    required this.order,
    required this.onPressed,
  }) : super(key: key);

  final ServiceOrder order;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        onPressed: () {
          onPressed();
        },
        icon: const Icon(
          Icons.check,
          color: ColorManager.primary,
        ),
      ),
    );
  }
}
