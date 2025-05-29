import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;

class LikedPostMainWidget extends StatefulWidget {
  const LikedPostMainWidget({super.key});

  @override
  State<LikedPostMainWidget> createState() => _LikedPostMainWidgetState();
}

class _LikedPostMainWidgetState extends State<LikedPostMainWidget> {

  void initState() {
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      context.read<CurrentUidCubit>().setUid(value);
      BlocProvider.of<PostCubit>(context).getLikedPosts(userId: value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liked Posts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if(postState is PostLoaded){
            final posts=postState.posts;
return ListView.builder(
            itemCount: posts.length, 
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name and profile pic
                      ListTile(
                        leading: profilewidget(imageUrl: posts[index].userProfileUrl),
                        title: Text(
                          posts[index].userName!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Post image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:profilewidget(imageUrl: posts[index].postImageUrl)
                      ),

                      const SizedBox(height: 8),

                      // Like icon and caption
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: const [
                            Icon(Icons.favorite, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'You liked this post',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
