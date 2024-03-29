import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/color_manager.dart';
import '../../../../config/values_manager.dart';
import '../../../auth/presentation/bloc/authentication_bloc.dart';
import '../../domain/entities/message.dart';
import '../blocs/chat_bloc/chat_bloc.dart';

class ChatTextField extends StatelessWidget {
  ChatTextField({super.key, this.onSended});

  final TextEditingController _chatController = TextEditingController();

  late final Sender sender;
  final Function? onSended;

  @override
  Widget build(BuildContext context) {
    var authState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (authState is AuthenticationSuccess) {
      var authUser = authState.employee;
      sender = Sender(name: authUser.name, email: authUser.email, id: authUser.employeeID);

      return Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(color: ColorManager.grey),
          borderRadius: BorderRadius.circular(AppSize.s15.r),
        ),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  if (onSended != null) onSended!();
                  if (_chatController.text.isNotEmpty) {
                    BlocProvider.of<ChatBloc>(context).add(
                        TextMessageSent(message: TextMessage.create(_chatController.text, sender)));
                    _chatController.clear();
                  }
                },
                icon: const Icon(
                  Icons.send,
                  color: ColorManager.primary,
                )),
            Expanded(
              child: TextField(
                controller: _chatController,
                decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  // focused border style
                  focusedBorder: InputBorder.none,
                  // error border style
                  errorBorder: InputBorder.none,
                  // focused error border style
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
