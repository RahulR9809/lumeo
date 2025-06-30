import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/theme/cubit/theme_cubit.dart';
import 'package:lumeo/features/presentation/page/about/about_screen.dart';
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
    // BlocProvider.of<GetSingleUserCubit>(
    //   context,
    // ).getSingleUser(uid: widget.currentUser.uid!);
    BlocProvider.of<PostCubit>(context).getPosts(post: PostEntity());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,

        title: Text(
          "${widget.currentUser.username}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _openBottomModelSheet(context, widget.currentUser);
            },
            icon:  Icon(Icons.menu, color: Theme.of(context).colorScheme.surface),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              children: [
                CircleAvatar(
                  radius: width * 0.1,
                  backgroundColor: const Color.fromARGB(255, 83, 82, 82),
                  child: ClipOval(
                    child: SizedBox(
                      width: width * 0.2,
                      height: width * 0.2,
                      child: profilewidget(
                        imageUrl: widget.currentUser.profileUrl,
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
                        count: "${widget.currentUser.totalPosts ?? 0}",
                        label: "Posts",
                      ),
                      GestureDetector(
                        onTap: () {
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
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.currentUser.name == "" ? widget.currentUser.username : widget.currentUser.name}",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      widget.currentUser.bio ?? '',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      widget.currentUser.link ?? '',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<PostCubit, PostState>(
            builder: (context, postState) {
              if (postState is PostFailure) {
                return Center(child: Text("Failed to load posts"));
              }
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
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: posts.length,
                  physics: const ScrollPhysics(),
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
                      child: SizedBox(
                        width: width * 0.3,
                        height: width * 0.3,
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
    );
  }

  _openBottomModelSheet(BuildContext context, currentUser) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 290,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
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
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
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
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
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
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),


sizeVer(5),
Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
Padding(
  padding: const EdgeInsets.only(left: 10),
  child: BlocBuilder<ThemeCubit, ThemeMode>(
    builder: (context, themeMode) {
      final isDark = themeMode == ThemeMode.dark;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                    Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.secondary),

          Switch(
            value: isDark,
            activeColor:darkGreyColor,
            onChanged: (value) {
              context.read<ThemeCubit>().toggleTheme(value);
            },
          ),
                    Icon(Icons.light_mode, color: Theme.of(context).colorScheme.secondary),

        ],
      );
    },
  ),
),



              sizeVer(5),
              Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                  child: Text(
                    "About",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),


              sizeVer(5),
              Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
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
                      color: Theme.of(context).colorScheme.surface,
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
