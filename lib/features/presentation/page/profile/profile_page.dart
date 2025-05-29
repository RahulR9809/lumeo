import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';

class ProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    BlocProvider.of<GetSingleUserCubit>(
      context,
    ).getSingleUser(uid: widget.currentUser.uid!);
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
    print('this is the current uid${widget.currentUser.uid}');
    print('this is the other uid${widget.currentUser.otherUid}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('here');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.currentUser.username}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openBottomModelSheet(context, widget.currentUser);
            },
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color.fromARGB(255, 83, 82, 82),
                  child: ClipOval(
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: profilewidget(
                        imageUrl: widget.currentUser.profileUrl,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ProfileStat(
                        count: "${widget.currentUser.totalPosts ?? 0}",
                        label: "Posts",
                      ),
                      GestureDetector(
                        onTap: (){
                            Navigator.pushNamed(
                            context,
                            PageConst.followersPage,
                            arguments: widget.currentUser,
                          );
                        },
                        child: _ProfileStat(
                          count: "${widget.currentUser.totalFollowers ?? 0}",
                          label: "Followers",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PageConst.followingPage,
                            arguments: widget.currentUser,
                          );
                        },
                        child: _ProfileStat(
                          count: "${widget.currentUser.following!.length}",
                          label: "Following",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.currentUser.name == "" ? widget.currentUser.username : widget.currentUser.name}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.currentUser.bio ?? '',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.currentUser.link ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),

          BlocBuilder<PostCubit, PostState>(
            builder: (context, postState) {
              if (postState is PostLoaded) {
                final posts =
                    postState.posts
                        .where(
                          (post) => post.creatorUid == widget.currentUser.uid,
                        )
                        .toList();
                return GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: posts.length,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageConst.postDetailPage,
                          arguments: posts[index].postId,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        child: profilewidget(
                          imageUrl: posts[index].postImageUrl,
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }

  _openBottomModelSheet(BuildContext context, currentUser) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 180,
          decoration: BoxDecoration(color: backGroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  "More Options",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: whiteColor,
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: secondaryColor),
              sizeVer(5),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "editProfilepage",
                      arguments: currentUser,
                    );
                  },
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: secondaryColor),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.savedPostpage);
                  },
                  child: Text(
                    "saved Post",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: secondaryColor),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PageConst.loginPage,
                      (route) => false,
                    );
                    BlocProvider.of<AuthCubit>(context).loggedOut();
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
