import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/app_localizations.dart';
import '../../../../../config/color_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/styles_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../../domain/entities/service_order.dart';
import '../../blocs/service_order_bloc/service_order_bloc.dart';

class PendingOrderCard extends StatelessWidget {
  const PendingOrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  final ServiceOrder order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showOrderDetailsDialog(context, order);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          // horizontal: AppSize.s8.w,
          vertical: AppSize.s8.h,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.s8.w,
          vertical: AppSize.s5.h,
        ),
        decoration: ShapeDecoration(
          shape: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppSize.s18.r),
          ),
          color: ColorManager.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Card(
                color: ColorManager.darkWhite,
                shape: const CircleBorder(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.orderNNumber.tr(context),
                      textAlign: TextAlign.center,
                      style: getAlmaraiBoldStyle(
                        fontSize: AppSize.s16.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                    SizedBox(height: AppSize.s2.h),
                    Text(
                      order.id.toString(),
                      textAlign: TextAlign.center,
                      style: getAlmaraiBoldStyle(
                        fontSize: AppSize.s16.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${AppStrings.service.tr(context)}: ${order.service.serviceName}",
                    style: getAlmaraiRegularStyle(
                      fontSize: AppSize.s18.sp,
                      color: ColorManager.primary,
                    ),
                  ),
                  Text(
                    "${AppStrings.price.tr(context)}: ${order.service.servicePrice}",
                    style: getAlmaraiRegularStyle(
                      fontSize: AppSize.s18.sp,
                      color: ColorManager.primary,
                    ),
                  ),
                  SizedBox(height: AppSize.s10.h),
                  SizedBox(height: AppSize.s4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showOrderDetailsDialog(BuildContext context, ServiceOrder order) async {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.orderNumber.tr(context)}: ${order.id}\n'
                '${AppStrings.company.tr(context)}: ${order.service.companyName}\n'
                '${AppStrings.service.tr(context)}: ${order.service.serviceName}\n'
                '${AppStrings.price.tr(context)}: ${order.service.servicePrice}\n'
                '${AppStrings.requesterName.tr(context)}: ${order.user.name}\n',
                style: Theme.of(context).textTheme.headline5!.copyWith(color: ColorManager.primary),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        var authState = BlocProvider.of<AuthenticationBloc>(context).state;
                        if (authState is AuthenticationSuccess) {
                          BlocProvider.of<ServiceOrderBloc>(context).add(AcceptOrder(
                              employee: authState.employee, serviceOrder: order, context: context));
                          Navigator.pop(context);
                        }
                      },
                      child: Text(AppStrings.accept.tr(context))),
                  SizedBox(width: AppSize.s10.h),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppStrings.cancel.tr(context)))
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
