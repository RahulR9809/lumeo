import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/home/widgets/single_post_card_widget.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  //   void initState() {
  //   di.sl<GetCurrentUidUsecase>().call().then((value){
  //     value
  //   })

  //     super.initState();
  //   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset("assets/logo.png", height: 60),
            Icon(MdiIcons.facebookMessenger, color: whiteColor, size: 28),
          ],
        ),
      ),
      body: BlocProvider<PostCubit>(
        create: (context) => di.sl<PostCubit>()..getPosts(post: PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, poststate) {
            if (poststate is PostLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (poststate is PostFailure) {
              toast("Some error occcured while creating the post");
            }
            if (poststate is PostLoaded) {
              return poststate.posts.isEmpty?_noPostFoundWidget(context):ListView.builder(
                itemCount: poststate.posts.length,
                itemBuilder: (context, index) {
                  final post = poststate.posts[index];
                  return SinglePostCardWidget(post: post);
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }



  Widget _noPostFoundWidget(BuildContext context) {
  final theme = Theme.of(context);

  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie animation
          Lottie.asset(
            'assets/animation/Animation - 1747482878812.json',
            width: 300,
            height: 200,
            repeat: true,
          ),

          const SizedBox(height: 20),

          Text(
            'No Posts Found',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Looks like there’s nothing to show here right now.\nTry creating a new post!',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 30),
  Lottie.asset(
            'assets/animation/Animation - 1747484207591.json',
            width: 150,
            height: 200,
            repeat: true,
          ),
      
        ],
      ),
    ),
  );
}

}
