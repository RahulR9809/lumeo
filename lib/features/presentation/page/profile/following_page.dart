
import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:lumeo/features/presentation/page/profile/widgets/no_followers_following.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;

class FollowingPage extends StatefulWidget {
  final UserEntity user;
  const FollowingPage({super.key, required this.user});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  @override
  Widget build(BuildContext context) {
    final following = widget.user.following;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Following",
          style: TextStyle(
            color: Theme.of(context).colorScheme.surface,
            fontSize: width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.surface),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.015,
        ),
        child: following == null || following.isEmpty
            ? const NoFollowersFollowing(
                text: "No Following Yet",
                text2: "Start following people to see them here.",
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: following.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                          stream: di.sl<GetSingleUserUsecase>().call(
                                following[index],
                              ),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.isEmpty) {
                              return Container();
                            }

                            final singleUserData = snapshot.data!.first;

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.01,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    PageConst.singleProfilePage,
                                    arguments: singleUserData.uid,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: width * 0.13,
                                      width: width * 0.13,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: profilewidget(
                                          imageUrl: singleUserData.profileUrl,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.04),
                                    Expanded(
                                      child: Text(
                                        singleUserData.username ?? '',
                                        style: TextStyle(
                                          fontSize: width * 0.045,
                                          color: Theme.of(context).colorScheme.surface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
