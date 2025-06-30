

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/page/home/home_page.dart';
import 'package:lumeo/features/presentation/page/liked_posts/liked_posts.dart';
import 'package:lumeo/features/presentation/page/post/upload_post_page.dart';
import 'package:lumeo/features/presentation/page/profile/profile_main_page.dart';
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
            extendBody: true,
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavIcon(Icons.home, 0),
                        _buildNavIcon(Icons.search, 1),
                        _buildCenterButton(),
                        _buildNavIcon(MdiIcons.heart, 3),
                        _buildNavIcon(Icons.person, 4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                HomePage(),
                SearchPage(),
                UploadPostPage(currentUser: currentUser),
                LikedPosts(),
                ProfileMainPage(currentUser: currentUser),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => navigationTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isActive ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.blueAccent : Theme.of(context).colorScheme.surface,
          size: 26,
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => navigationTapped(2),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.blueAccent.withOpacity(0.6),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.add, size: 30, color: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}
