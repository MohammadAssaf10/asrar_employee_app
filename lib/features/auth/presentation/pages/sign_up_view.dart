import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/color_manager.dart';
import '../../../../config/strings_manager.dart';
import '../../../../config/app_localizations.dart';
import '../../../../config/values_manager.dart';
import '../../../../core/app/functions.dart';
import '../../domain/entities/entities.dart';
import '../common/widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  EmployeeTextFields _textFields = EmployeeTextFields();
  EmployeeImages _images = EmployeeImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
              center: Alignment.center,
              focal: Alignment.topCenter,
              radius: 4,
              colors: [
                ColorManager.primary,
                Colors.white,
              ]),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.s30.w, vertical: AppSize.s18.h),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSize.s20.h,
                ),
                const RegisterText(),
                SizedBox(height: AppSize.s20.h),
                RegisterTextForms(
                  onChange: (v) {
                    _textFields = v;
                  },
                ),
                SizedBox(height: 10.h),
                RegisterImagesFields(
                  onChange: (v) {
                    _images = v;
                  },
                ),
                FullElevatedButton(
                    onPressed: () {
                      if (!_textFields.isAllFieldsFiled()) {
                        showCustomDialog(context,
                            message: AppStrings.enterAllFields.tr(context));
                      } else if (!_images.isAllFieldsFiled()) {
                        showCustomDialog(context,
                            message: AppStrings.enterAllImages.tr(context));
                      }
                    },
                    text: AppStrings.registerNewAccount.tr(context)),
              ],
            )),
          ),
        ),
      ),
    );
  }
}

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
            if (v != null) {
              _images.id = v;
            } else {
              _images.id = null;
            }
            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.address.tr(context),
          onChange: (v) {
            if (v != null) {
              _images.address = v;
            } else {
              _images.address = null;
            }
            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.personalPhoto.tr(context),
          onChange: (v) {
            if (v != null) {
              _images.personal = v;
            } else {
              _images.personal = null;
            }
            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.bankIBANCertificate.tr(context),
          onChange: (v) {
            if (v != null) {
              _images.bankIBAN = v;
            } else {
              _images.bankIBAN = null;
            }
            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.commercialRegistryInstitutions.tr(context),
          onChange: (v) {
            if (v != null) {
              _images.commercial = v;
            } else {
              _images.commercial = null;
            }
            if (onChange != null) {
              onChange!(_images);
            }
          },
        ),
        FileButton(
          text: AppStrings.pictureOfTheHeadquarters.tr(context),
          onChange: (v) {
            if (v != null) {
              _images.headquarters = v;
            } else {
              _images.headquarters = null;
            }
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
