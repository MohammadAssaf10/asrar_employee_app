import 'package:asrar_employee_app/config/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../../config/color_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../../../../core/app/functions.dart';
import '../../../../auth/domain/entities/employee.dart';
import '../../../data/requests/employees_updates.dart';
import '../../blocs/employee_bloc/employee_bloc.dart';
import '../../widgets/general/input_form_field.dart';
import '../../../../../core/app/extensions.dart';
import '../../widgets/general/optionButton.dart';

class YourAccountScreen extends StatelessWidget {
  const YourAccountScreen(this.employee, {super.key});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController =
        TextEditingController(text: employee.email);
    final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
    final TextEditingController nameController =
        TextEditingController(text: employee.name);
    final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
    final TextEditingController phoneController = TextEditingController(
        text: employee.phoneNumber.substring(3, employee.phoneNumber.length));
    final GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
    String phoneNumber = employee.phoneNumber;
    String countryCode = '+966';
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.yourAccount.tr(context),
          ),
        ),
        body: BlocListener<EmployeeBloc, EmployeeState>(
          listener: (context, state) {
            if (state is EmployeeLoadingState) {
              showCustomDialog(context);
            } else if (state is EmployeeErrorState) {
              showCustomDialog(context,
                  message: state.errorMessage.tr(context));
            } else if (state is EmployeeInfoUpdatedSuccessfullyState) {
              showCustomDialog(context,
                  message: AppStrings.requestAddedToUpdateInformation.tr(context));
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputFormField(
                  formKey: emailKey,
                  controller: emailController,
                  labelText: AppStrings.email.tr(context),
                  regExp: getTextWithNumberInputFormat(),
                  textInputType: TextInputType.emailAddress,
                  horizontalContentPadding: AppSize.s12.w,
                  validator: (String? email) {
                    if (email.nullOrEmpty()) {
                      return AppStrings.pleaseEnterEmail.tr(context);
                    }
                    if (!isEmailFormatCorrect(email!)) {
                      return AppStrings.emailFormatNotCorrect.tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s20.h),
                InputFormField(
                  formKey: nameKey,
                  controller: nameController,
                  labelText: AppStrings.userName.tr(context),
                  regExp: getAllKeyboradInputFormat(),
                  textInputType: TextInputType.text,
                  horizontalContentPadding: AppSize.s12.w,
                  validator: (String? name) {
                    if (name.nullOrEmpty()) {
                      return AppStrings.pleaseEnterUserName.tr(context);
                    }
                    if (name!.length < 3) {
                      return AppStrings.userNameShouldAtLeast3Character
                          .tr(context);
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSize.s20.h),
                Form(
                  key: phoneKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: IntlPhoneField(
                    controller: phoneController,
                    invalidNumberMessage:
                        AppStrings.mobileNumberFormatNotCorrect.tr(context),
                    // ignore: deprecated_member_use
                    searchText: AppStrings.searchCountry.tr(context),
                    dropdownIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: ColorManager.primary,
                    ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'SA',
                    onChanged: (phone) {
                      countryCode = phone.countryCode;
                      phoneNumber = phone.number;
                      if (phoneNumber[0] == '0') {
                        phoneNumber = phoneNumber.replaceFirst('0', '');
                      }
                      phoneNumber = countryCode + phoneNumber;
                      phoneNumber
                          .replaceAll(' ', '')
                          .replaceAll('-', '')
                          .replaceAll('+', '');
                    },
                  ),
                ),
                SizedBox(height: AppSize.s30.h),
                OptionButton(
                  onTap: () {
                    if (emailKey.currentState!.validate() &&
                        nameKey.currentState!.validate() &&
                        phoneKey.currentState!.validate()) {
                      final EmployeeUpdatesRequest employeeUpdates =
                          EmployeeUpdatesRequest(
                        employeeID: employee.employeeID,
                        timeStamp: Timestamp.now(),
                        oldName: employee.name,
                        newName: nameController.text,
                        oldPhoneNumber: employee.phoneNumber,
                        newPhoneNumber: phoneNumber.replaceAll("+", ""),
                      );
                      BlocProvider.of<EmployeeBloc>(context)
                          .add(UpdateEmployeeInfo(
                        employeeUpdates: employeeUpdates,
                        newEmail: emailController.text,
                      ));
                    }
                  },
                  title: AppStrings.save.tr(context),
                  height: AppSize.s40.h,
                  width: AppSize.s150.w,
                  fontSize: AppSize.s20.sp,
                ),
              ],
            ),
          ),
        ));
  }
}
