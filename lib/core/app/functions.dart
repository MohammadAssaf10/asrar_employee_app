import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../config/color_manager.dart';
import '../../config/strings_manager.dart';
import '../../config/styles_manager.dart';
import '../../config/values_manager.dart';
import '../../config/app_localizations.dart';
import '../../core/app/extensions.dart';
import '../../features/chat/domain/entities/file_entities.dart';

String? nameValidator(String? name, BuildContext context) {
  if (name.nullOrEmpty()) {
    return ""; //AppStrings.pleaseEnterName.tr(context);
  }

  if (name!.length < 3) {
    return ""; //AppStrings.nameTooShort.tr(context);
  }

  return null;
}

String? mobileNumberValidator(String? phone, BuildContext context) {
  if (phone.nullOrEmpty()) {
    return ""; //AppStrings.pleaseEnterName.tr(context);
  }

  if (!isMobileNumberCorrect(phone!)) {
    return AppStrings.mobileNumberFormatNotCorrect.tr(context);
  }

  return null;
}

String? emailValidator(String? email, BuildContext context) {
  if (email.nullOrEmpty()) {
    return ""; //AppStrings.pleaseEnterName.tr(context);
  }

  if (!isEmailFormatCorrect(email!)) {
    return ""; //AppStrings.emailFormatNotCorrect.tr(context);
  }

  return null;
}

String? cantBeEmpty(String? v, BuildContext context) {
  if (v.nullOrEmpty()) {
    return '';
  }

  return null;
}

bool isEmailFormatCorrect(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool isMobileNumberCorrect(String mobileNumber) {
  return RegExp(r"^[+]*[0-9]+").hasMatch(mobileNumber);
}

_isCurrentDialogShowing(BuildContext context) =>
    ModalRoute.of(context)?.isCurrent != true;

dismissDialog(BuildContext context) {
  if (_isCurrentDialogShowing(context)) {
    Navigator.of(context, rootNavigator: true).pop(true);
  }
}

void showCustomDialog(BuildContext context,
    {String? message, String? jsonPath}) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    dismissDialog(context);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (jsonPath != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s10.h,
                  horizontal: AppSize.s10.w,
                ),
                child: Lottie.asset(jsonPath),
              ),
            if (message != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s10.h,
                  horizontal: AppSize.s10.w,
                ),
                child: Center(
                  child: Text(
                    message,
                    style: getAlmaraiRegularStyle(
                      fontSize: AppSize.s16.sp,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
              ),
            if (jsonPath == null && message == null)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s8.h,
                  horizontal: AppSize.s8.w,
                ),
                child: const CircularProgressIndicator(
                  color: ColorManager.primary,
                ),
              ),
          ],
        ),
      ),
    );
  });
}

Future<FileEntities> uploadFile(String path, XFile xFile) async {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final Reference ref = firebaseStorage.ref(path);
  await ref.putFile(File(xFile.path));
  final fileURL = await ref.getDownloadURL();
  final FileEntities file = FileEntities(name: xFile.name, url: fileURL);
  return file;
}

// fullPath: file path with name
Future<void> deleteFile(String fullPath) async {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final Reference ref = firebaseStorage.ref(fullPath);
  await ref.delete();
}

Future<XFile?> selectFile(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            AppStrings.selectImageSource.tr(context),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                AppStrings.camera.tr(context),
              ),
              onPressed: () async {
                Navigator.pop(context,
                    await picker.pickImage(source: ImageSource.camera));
              },
            ),
            SimpleDialogOption(
              child: Text(
                AppStrings.gallery.tr(context),
              ),
              onPressed: () async {
                Navigator.pop(context,
                    await picker.pickImage(source: ImageSource.gallery));
              },
            )
          ],
        );
      });
  return image;
}
