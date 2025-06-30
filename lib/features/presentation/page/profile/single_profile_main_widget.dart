import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/get_single_other_user/cubit/get_single_other_user_cubit.dart';
import 'package:lumeo/features/presentation/widgets/bottom_container_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SingleProfileMainWidget extends StatefulWidget {
  final String otherUserId;
  const SingleProfileMainWidget({required this.otherUserId, super.key});

  @override
  State<SingleProfileMainWidget> createState() =>
      _SingleProfileMainWidgetState();
}

class _SingleProfileMainWidgetState extends State<SingleProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleOtherUserCubit>(
      context,
    ).getSingleOtherUser(otherUid: widget.otherUserId);
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      context.read<CurrentUidCubit>().setUid(value);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final currentUid = context.watch<CurrentUidCubit>().state;
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
      builder: (context, getSingleOtherUserLoaded) {
        if (getSingleOtherUserLoaded is GetSingleOtherUserLoaded) {
          final singleuser = getSingleOtherUserLoaded.otherUser;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.primary,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.surface),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${singleuser.username}",
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                        currentUid == singleuser.uid
                            ? InkWell(
                              onTap:
                                  () => _openbottomModelSheet(
                                    context,
                                    singleuser,
                                  ),
                              child: Icon(MdiIcons.menu),
                            )
                            : const SizedBox.shrink(),
                      ],
                    ),
                    sizeVer(height * 0.01),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: width * 0.1,
                          backgroundColor: const Color.fromARGB(
                            255,
                            83,
                            82,
                            82,
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: width * 0.2,
                              height: width * 0.2,
                              child: profilewidget(
                                imageUrl: singleuser.profileUrl,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.05),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _ProfileStat(
                                count: "${singleuser.totalPosts ?? 0}",
                                label: "Posts",
                              ),
                              _ProfileStat(
                                count: "${singleuser.totalFollowers ?? 0}",
                                label: "Followers",
                              ),
                              _ProfileStat(
                                count: "${singleuser.following!.length}",
                                label: "Following",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sizeVer(height * 0.015),
                    Text(
                      '${singleuser.name == "" ? singleuser.username : singleuser.name}',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Text(
                      ' ${singleuser.bio}',
                      style: TextStyle(
                        fontSize: width * 0.032,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    Text(
                      singleuser.link ?? '',
                      style: TextStyle(
                        fontSize: width * 0.032,
                        color: Colors.blue,
                      ),
                    ),
                    sizeVer(height * 0.015),
                    currentUid == singleuser.uid
                        ? SizedBox(height: width * 0.05, width: width * 0.05)
                        : BottomContainerWidget(
                          text:
                              singleuser.followers!.contains(currentUid)
                                  ? "UnFollow"
                                  : "Follow",
                          color:
                              singleuser.followers!.contains(currentUid)
                                  ? Theme.of(context).colorScheme.secondary
                                  : blueColor,
                          onTapListener: () {
                            BlocProvider.of<UserCubit>(context).followUser(
                              user: UserEntity(
                                uid: currentUid,
                                otherUid: widget.otherUserId,
                              ),
                            );
                          },
                        ),
                    sizeVer(height * 0.015),
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, poststate) {
                        if (poststate is PostLoaded) {
                          final posts =
                              poststate.posts
                                  .where(
                                    (post) =>
                                        post.creatorUid == widget.otherUserId,
                                  )
                                  .toList();
                          return GridView.builder(
                            itemCount: posts.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  crossAxisCount: 3,
                                ),
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: width * 0.3,
                                height: width * 0.3,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      PageConst.postDetailPage,
                                      arguments: posts[index].postId,
                                    );
                                  },
                                  child: profilewidget(
                                    imageUrl: posts[index].postImageUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

logOut(context) {
  return showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                BlocProvider.of<AuthCubit>(context).loggedOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  PageConst.loginPage,
                  (route) => false,
                );
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
  );
}

class _ProfileStat extends StatelessWidget {
  final String count;
  final String label;

  const _ProfileStat({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style:  TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        Text(label, style:  TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.surface)),
      ],
    );
  }
}

_openbottomModelSheet(context, currentUser) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 180,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            sizeVer(10),
            const Text(
              'More Options',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            sizeVer(10),
             Divider(color: Theme.of(context).colorScheme.secondary),
            GestureDetector(
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    PageConst.editProfilepage,
                    arguments: currentUser,
                  ),
              child: const Text('Edit profile'),
            ),
            sizeVer(10),
             Divider(color: Theme.of(context).colorScheme.secondary),
            GestureDetector(
              onTap:
                  () => Navigator.pushNamed(context, PageConst.savedPostpage),
              child: const Text('Saved Posts'),
            ),
            sizeVer(10),
             Divider(color: Theme.of(context).colorScheme.secondary),
            InkWell(
              onTap: () async {
                logOut(context);
              },
              child: const Text('LogOut'),
            ),
          ],
        ),
      );
    },
  );
}
