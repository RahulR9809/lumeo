import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/page/chat/userlist_main_widget.dart';
import 'package:lumeo/injection_container.dart' as di;


class Userlistpage extends StatelessWidget {
  const Userlistpage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>di.sl<UserCubit>(),
      child: UsersListMainWidget(getCurrentUuidUsecase: di.sl<GetCurrentUuidUsecase>()));
  }
}