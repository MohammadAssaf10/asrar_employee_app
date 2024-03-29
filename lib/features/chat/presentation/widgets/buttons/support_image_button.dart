import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../config/color_manager.dart';
import '../../../../../core/app/functions.dart';
import '../../../domain/entities/message.dart';
import '../../blocs/support_chat/support_chat_bloc.dart';

class SupportImageButton extends StatelessWidget {
  const SupportImageButton({
    Key? key,
    required this.onSended,
    required this.sender,
  }) : super(key: key);

  final Function? onSended;
  final Sender sender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
          onTap: () async {
            onSended;
            XFile? image = await selectFile(context);
            if (image != null) {
              BlocProvider.of<SupportChatBloc>(context)
                  .add(ImageMessageSent(image, ImageMessage.create(sender)));
            }
          },
          child: const Icon(
            Icons.camera_alt,
            color: ColorManager.primary,
          )),
    );
  }
}