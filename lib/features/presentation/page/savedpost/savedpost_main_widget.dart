import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/savedposts/savedpost_cubit.dart';
import 'package:lumeo/features/presentation/cubit/savedposts/savedpost_state.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;

class SavedpostMainWidget extends StatefulWidget {
  const SavedpostMainWidget({super.key});

  @override
  State<SavedpostMainWidget> createState() => _SavedpostMainWidgetState();
}

class _SavedpostMainWidgetState extends State<SavedpostMainWidget> {
  @override
  void initState() {
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      context.read<CurrentUidCubit>().setUid(value);
      BlocProvider.of<SavedpostCubit>(context).getSavedPost(userId: value);
    });
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Saved Posts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SvgPicture.asset("assets/logo.png", height: 50),
            ),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<SavedpostCubit, SavedpostState>(
              builder: (context, poststate) {
                if (poststate is SavedPostLoaded) {
                  final posts = poststate.posts;
                  return Expanded(
                    child: GridView.builder(
                      itemCount: posts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            crossAxisCount: 3,
                          ),
                      itemBuilder:
                          (context, index) => GestureDetector(
                            onTap:
                                () => Navigator.pushNamed(
                                  context,
                                  PageConst.postDetailPage,
                                  arguments: posts[index].postId,
                                ),
                            child: profilewidget(
                              imageUrl: posts[index].postImageUrl,
                            ),
                          ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
