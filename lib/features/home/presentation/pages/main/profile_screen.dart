import 'package:asrar_employee_app/config/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../config/color_manager.dart';
import '../../../../../config/routes_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/styles_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../../../../core/app/functions.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../../data/requests/employees_updates.dart';
import '../../blocs/employee_bloc/employee_bloc.dart';
import '../../widgets/general/error_view.dart';
import '../../widgets/general/list_tile.dart';
import '../../widgets/general/loading_view.dart';
import '../../widgets/general/optionButton.dart';
import '../../widgets/general/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    final authState = BlocProvider.of<AuthenticationBloc>(context).state;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile.tr(context))),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is ImageUpdatedSuccessfullyState) {
            showCustomDialog(context,
                message: AppStrings.requestAddedToUpdateProfileImage.tr(context));
            if (authState is AuthenticationSuccess) {
              BlocProvider.of<EmployeeBloc>(context).add(
                GetEmployeeInfo(id: authState.employee.employeeID),
              );
            }
          } else if (state is PasswordUpdatedLoadingState) {
            showCustomDialog(context);
          }
          if (state is PasswordUpdatedErrorState) {
            showCustomDialog(context, message: state.errorMessage.tr(context));
            if (authState is AuthenticationSuccess) {
              BlocProvider.of<EmployeeBloc>(context).add(
                GetEmployeeInfo(id: authState.employee.employeeID),
              );
            }
          }
          if (state is PasswordUpdatedSuccessfullyState) {
            showCustomDialog(context,
                message: AppStrings.passwordUpdated.tr(context));
            if (authState is AuthenticationSuccess) {
              BlocProvider.of<EmployeeBloc>(context).add(
                GetEmployeeInfo(id: authState.employee.employeeID),
              );
            }
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoadingState) {
            return LoadingView(
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
            );
          } else if (state is EmployeeErrorState) {
            return ErrorView(
              errorMessage: state.errorMessage,
              height: MediaQuery.of(context).size.height / 1.3,
              width: MediaQuery.of(context).size.width,
            );
          } else if (state is EmployeeLoadedState) {
            return ListView(
              shrinkWrap: true,
              children: [
                ProfileImage(
                  userImage: state.employee.imageURL,
                  imagePicked: image?.path,
                  onPress: () async {
                    XFile? imageSelected = await selectFile(context);
                    setState(() {
                      image = imageSelected;
                    });
                  },
                ),
                Text(
                  state.employee.name,
                  textAlign: TextAlign.center,
                  style: getAlmaraiBoldStyle(
                    fontSize: AppSize.s20.sp,
                    color: ColorManager.primary,
                  ),
                ),
                image == null
                    ? SizedBox(height: AppSize.s60.h)
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.s15.h),
                        child: OptionButton(
                          onTap: () {
                            final EmployeeUpdatesRequest employeeUpdateRequest =
                                EmployeeUpdatesRequest(
                              timeStamp: Timestamp.now(),
                              employeeID: state.employee.employeeID,
                              oldImageName: state.employee.imageName,
                              oldImageURL: state.employee.imageURL,
                              newImageName: image!.name,
                              oldName: state.employee.name,
                              oldPhoneNumber: state.employee.phoneNumber,
                            );
                            BlocProvider.of<EmployeeBloc>(context).add(
                              UpdateEmployeeImageEvent(
                                  employeeUpdates: employeeUpdateRequest,
                                  xFile: image!),
                            );
                            image = null;
                          },
                          title: AppStrings.save.tr(context),
                          height: AppSize.s30.h,
                          width: AppSize.s120.w,
                          fontSize: AppSize.s20.sp,
                        ),
                      ),
                ListTile(
                  title: Text(
                    "السماح باظهار الاشعارات\nعلى الشاشة الرئيسية",
                    style: getAlmaraiRegularStyle(
                      fontSize: AppSize.s18.sp,
                      color: ColorManager.darkGrey,
                    ),
                  ),
                  trailing: Switch.adaptive(
                    activeColor: ColorManager.primary,
                    value: true,
                    onChanged: (v) {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s10.w,
                    vertical: AppSize.s5.h,
                  ),
                  child: Text(
                    AppStrings.advancedSettings.tr(context),
                    textAlign: TextAlign.start,
                    style: getAlmaraiBoldStyle(
                      fontSize: AppSize.s22.sp,
                      color: ColorManager.primary,
                    ),
                  ),
                ),
                ListTileWidget(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.yourAccountRoute,
                      arguments: state.employee,
                    );
                  },
                  title: AppStrings.yourAccount.tr(context),
                  icon: Icons.person_outline,
                ),
                Divider(
                  height: AppSize.s1.h,
                  thickness: AppSize.s0_5.h,
                  color: ColorManager.grey,
                ),
                ListTileWidget(
                  onTap: () {
                    showNewPasswordDialog(
                      context,
                      newPasswordController,
                      formKey,
                      () {
                        if (formKey.currentState!.validate()) {
                          BlocProvider.of<EmployeeBloc>(context).add(
                            UpdatePasswordEvent(
                                newPassword: newPasswordController.text),
                          );
                        }
                      },
                    );
                  },
                  title: AppStrings.changePassword.tr(context),
                  icon: Icons.lock_outline_rounded,
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
