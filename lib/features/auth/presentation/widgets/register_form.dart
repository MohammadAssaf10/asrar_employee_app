import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/app_localizations.dart';
import '../../../../config/color_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/values_manager.dart';
import '../../../../core/app/functions.dart';
import '../../domain/entities/entities.dart';
import 'widgets.dart';

class RegisterText extends StatelessWidget {
  const RegisterText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.registerNow.tr(context),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: ColorManager.white),
        ),
        Text(
          AppStrings.toRegisterWithUsPleaseFill.tr(context),
          style: const TextStyle(color: ColorManager.white),
        ),
      ],
    );
  }
}

class RegisterTextForms extends StatelessWidget {
  RegisterTextForms({super.key, this.onChange});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final EmployeeTextFields _employeeTextFields = EmployeeTextFields();
  final Function(EmployeeTextFields)? onChange;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _key,
      child: Column(
        children: [
          TextFrom(
            label: AppStrings.name.tr(context),
            onChange: (v) {
              _employeeTextFields.name = v;
              if (onChange != null) {
                onChange!(_employeeTextFields);
              }
            },
            validator: (name) => nameValidator(name, context),
          ),
          TextFrom(
            label: AppStrings.mobileNumber.tr(context),
            onChange: (v) {
              _employeeTextFields.phonNumber = v;
              if (onChange != null) {
                onChange!(_employeeTextFields);
              }
            },
            validator: (phone) => mobileNumberValidator(phone, context),
          ),
          TextFrom(
            label: AppStrings.email.tr(context),
            onChange: (v) {
              _employeeTextFields.email = v;
              if (onChange != null) {
                onChange!(_employeeTextFields);
              }
            },
            validator: (email) => emailValidator(email, context),
          ),
          TextFrom(
            label: AppStrings.password.tr(context),
            onChange: (v) {
              _employeeTextFields.password = v;
              if (onChange != null) {
                onChange!(_employeeTextFields);
              }
            },
            validator: (v) => cantBeEmpty(v, context),
          ),
          TextFrom(
            label: AppStrings.idNumber.tr(context),
            onChange: (v) {
              _employeeTextFields.idNumber = v;
              if (onChange != null) {
                onChange!(_employeeTextFields);
              }
            },
            validator: (v) => cantBeEmpty(v, context),
          ),
          TextFrom(
            label: AppStrings.nationality.tr(context),
            onChange: (v) {
              _employeeTextFields.national = v;
              if (onChange != null) {
                onChange!(_employeeTextFields);
              }
            },
            validator: (v) => cantBeEmpty(v, context),
          ),
        ],
      ),
    );
  }
}

class RegisterImagesFields extends StatelessWidget {
  RegisterImagesFields({super.key, this.onChange});

  final EmployeeImages _images = EmployeeImages();

  final Function(EmployeeImages)? onChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FileButton(
          text: AppStrings.id.tr(context),
          onChange: (v) {
            _images.id = v;

            // todo delete
            _images.address = v;
            _images.personal = v;
            _images.bankIBAN = v;
            _images.commercial = v;
            _images.headquarters = v;
            //
            
            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.address.tr(context),
          onChange: (v) {
            _images.address = v;

            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.personalPhoto.tr(context),
          onChange: (v) {
            _images.personal = v;

            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.bankIBANCertificate.tr(context),
          onChange: (v) {
            _images.bankIBAN = v;

            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.commercialRegistryInstitutions.tr(context),
          onChange: (v) {
            _images.commercial = v;

            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.pictureOfTheHeadquarters.tr(context),
          onChange: (v) {
            _images.headquarters = v;

            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        SizedBox(
          height: AppSize.s30.h,
        ),
      ],
    );
  }
}
