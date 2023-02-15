import 'package:flutter/material.dart';

import '../../../../../config/color_manager.dart';
import '../../../domain/entities/service_order.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
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
          Icons.delete,
          color: ColorManager.primary,
        ),
      ),
    );
  }
}
