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

    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text("Following"),
        backgroundColor: backGroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          stream: di.sl<GetSingleUserUsecase>().call(following[index]),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.data!.isEmpty) {
                              return Container();
                            }

                            final singleUserData = snapshot.data!.first;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, PageConst.singleProfilePage,arguments:singleUserData.uid );
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(60),
                                        child: profilewidget(
                                          imageUrl: singleUserData.profileUrl,
                                        ),
                                      ),
                                    ),
                                    sizeHor(10),
                                    Text(
                                      singleUserData.username ?? '',
                                      style: const TextStyle(fontSize: 16),
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
