import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final width = MediaQuery.of(context).size.width;

  return SafeArea(
    child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,

 appBar: AppBar(
  backgroundColor: Theme.of(context).colorScheme.primary,
  leading: IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.surface,),
  ),
  centerTitle: true,
  title: Text(
    'Saved Posts',
    style: TextStyle(
      fontSize: width * 0.05,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.surface,
    ),
  ),
),

      body: Column(
        children: [
          BlocBuilder<SavedpostCubit, SavedpostState>(
            builder: (context, poststate) {
              if (poststate is SavedPostLoaded) {
                final posts = poststate.posts;
                
      if (posts.isEmpty) {
        return const Expanded(
          child: Center(
            child: Text(
              'No Saved Posts',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }
                return Expanded(
                  child: GridView.builder(
                    itemCount: posts.length,
                    padding: EdgeInsets.all(width * 0.02),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: width * 0.01,
                      crossAxisSpacing: width * 0.01,
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        PageConst.postDetailPage,
                        arguments: posts[index].postId,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(width * 0.015),
                        child: profilewidget(
                          imageUrl: posts[index].postImageUrl,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    ),
  );
}
}
