import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/chat/userlistpage.dart';
import 'package:lumeo/features/presentation/page/home/widgets/single_post_card_widget.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
              Image.asset(
    Theme.of(context).brightness == Brightness.dark
        ? 'assets/dark_logo-removebg-preview.png'
        : 'assets/white_logo-removebg-preview.png',
    height: 60,
  ),

            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Userlistpage()));
              },
              child: Icon(MdiIcons.facebookMessenger, color: Theme.of(context).colorScheme.surface, size: 28)),
          ],
        ),
      ),

      body: BlocProvider<PostCubit>(
        create: (context) => di.sl<PostCubit>()..getPosts(post: PostEntity()),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, poststate) {
            if (poststate is PostLoading) {
              // return Center(child: CircularProgressIndicator());
              return  Center(
        child: Lottie.asset(
          'assets/animation/new Animation.json',
          width: 150,
          height: 150,
        ),
      );
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Looks like there’s nothing to show here right now.\nTry creating a new post!',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
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
