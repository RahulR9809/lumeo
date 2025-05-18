import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/page/home/home_page.dart';
import 'package:lumeo/features/presentation/page/liked_posts/liked_posts.dart';
import 'package:lumeo/features/presentation/page/post/upload_post_page.dart';
import 'package:lumeo/features/presentation/page/profile/profile_page.dart';
import 'package:lumeo/features/presentation/page/search/search_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainScreen extends StatefulWidget {
  final String uid;
    final int? index;
  const MainScreen({super.key, required this.uid, this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late PageController pageController;

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    pageController = PageController();
    super.initState();
    _currentIndex = widget.index ?? 0;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, getSingleUserState) {
        if (getSingleUserState is GetSingleUserLoaded) {
          final currentUser = getSingleUserState.user;
          return Scaffold(
            bottomNavigationBar: CupertinoTabBar(
              backgroundColor: backGroundColor,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: whiteColor),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search, color: whiteColor),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle, color: whiteColor),
                  label: 'post',
                ),
                BottomNavigationBarItem(
                  icon: Icon(MdiIcons.heart, color: whiteColor),
                  label: 'Liked',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: whiteColor),
                  label: 'profile',
                ),
              ],
              onTap: navigationTapped,
            ),
            body: PageView(
              controller: pageController,
              children: [
                HomePage(),
                SearchPage(),
                UploadPostPage(currentUser: currentUser,),
                LikedPostPage(),
                ProfilePage(currentUser: currentUser),
              ],
              onPageChanged: onPageChanged,
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
