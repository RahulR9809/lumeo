
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/home/widgets/full_screen_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;

class LikedPostMainWidget extends StatefulWidget {
  const LikedPostMainWidget({super.key});

  @override
  State<LikedPostMainWidget> createState() => _LikedPostMainWidgetState();
}

class _LikedPostMainWidgetState extends State<LikedPostMainWidget> {
  @override
  void initState() {
    super.initState();
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      context.read<CurrentUidCubit>().setUid(value);
      context.read<PostCubit>().getLikedPosts(userId: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,

        title:  Text(
          'Liked Posts',
          style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.surface),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if (postState is PostLoaded) {
            final posts = postState.posts;
         
      if (posts.isEmpty) {
        return const Expanded(
          child: Center(
            child: Text(
              'No Liked Posts',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }
            return ListView.builder(
              padding: EdgeInsets.all(width * 0.03),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: height * 0.010,horizontal: width*0.020),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User info
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                                 onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    PageConst.singleProfilePage,
                                    arguments: post.creatorUid,
                                  );
                                },
                              child: profilewidget(imageUrl: post.userProfileUrl)),
                          ),
                        ),
                        title: Text(
                          post.userName ?? "No Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.045,
                          ),
                        ),
                      ),

                      // Post image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: height * 0.3,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FullScreenImagePage(
                                        imageUrl: post.postImageUrl ?? '',
                                      ),
                                ),
                              );
                            },
                            child: profilewidget(imageUrl: post.postImageUrl),
                          ),
                        ),
                      ),

                      // Like & message
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.015,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: width * 0.06,
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              'You liked this post',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: width * 0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
