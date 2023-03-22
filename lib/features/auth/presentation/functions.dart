import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/assets_manager.dart';
import '../../../config/routes_manager.dart';
import '../../../config/strings_manager.dart';
import '../../../config/app_localizations.dart';
import '../../../core/app/functions.dart';
import 'bloc/authentication_bloc.dart';

ShapeBorder roundedBorder({double radius = 30}) =>
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius.r));

manageDialog(BuildContext context, AuthenticationState state) {
  if (state is AuthenticationInProgress) {
    if (state is UploadingImages) {
      showCustomDialog(context, message: "uploading ${state.message}");
    } else {
      showCustomDialog(context);
    }
  } else if (state is AuthenticationFailed) {
    showCustomDialog(context, jsonPath: JsonAssets.error, message: state.message.tr(context));
  } else if (state is AuthenticationSuccess) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      dismissDialog(context);
      Navigator.pushReplacementNamed(context, Routes.homeRoute);
    });
  } else if (state is ResetPasswordRequestSuccess) {
    showCustomDialog(context, message: AppStrings.resetEmailSendMessage.tr(context));
  }
}

Future<XFile?> openImagePicker(BuildContext context) async {
  final ImagePicker picker = ImagePicker();

  XFile? image = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(AppStrings.selectImageSource.tr(context)),
        children: [
          SimpleDialogOption(
            child: Text(AppStrings.camera.tr(context)),
            onPressed: () async {
              Navigator.pop(context, await picker.pickImage(source: ImageSource.camera));
            },
          ),
          SimpleDialogOption(
            child: Text(AppStrings.gallery.tr(context)),
            onPressed: () async {
              Navigator.pop(context, await picker.pickImage(source: ImageSource.gallery));
            },
          ),
        ],
      );
    },
  );
  return image;
}
