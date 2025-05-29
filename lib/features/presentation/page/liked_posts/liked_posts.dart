import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/liked_posts/liked_post_main_widget.dart';
import 'package:lumeo/injection_container.dart' as di;

class LikedPosts extends StatelessWidget {
  const LikedPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => di.sl<PostCubit>(),
      child: LikedPostMainWidget(),
    );
  }
}
