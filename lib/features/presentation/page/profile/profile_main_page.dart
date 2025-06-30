import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart' show PostCubit;
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/page/profile/profile_page.dart';

class ProfileMainPage extends StatelessWidget {
  final UserEntity currentUser;
  const ProfileMainPage({ super.key, required this.currentUser,});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
         BlocProvider.value(value: context.read<PostCubit>()),
        BlocProvider.value(value: context.read<GetSingleUserCubit>()),
        ],
         child: ProfilePage(currentUser: currentUser),);
  }
}
