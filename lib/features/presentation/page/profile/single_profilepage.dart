import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/page/profile/single_profile_main_widget.dart';
import 'package:lumeo/injection_container.dart' as di;


class SingleProfilePage extends StatelessWidget {
  final String otheruserId;
  const SingleProfilePage({required this.otheruserId, super.key,});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<GetSingleUserCubit>(create: (context) => di.sl<GetSingleUserCubit>()),
          BlocProvider(create: (context)=>di.sl<PostCubit>())
        ],
        child: SingleProfileMainWidget(
          otherUserId: otheruserId,
        ));
  }
}
