import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    sizeHor(10),
                    Text(
                      "Username",
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _openBottomModelSheet(context);
                  },
                  child: Icon(Icons.more_vert, color: whiteColor),
                ),
              ],
            ),
            sizeVer(10),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              color: secondaryColor,
            ),
            sizeVer(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite_outline, color: whiteColor),
                    sizeHor(10),
                    GestureDetector(
                      onTap: () {
                     Navigator.pushNamed(context, PageConst.commentPage);
                      },
                      child: Icon(MdiIcons.commentOutline, color: whiteColor),
                    ),
                    sizeHor(10),
                    Icon(MdiIcons.sendOutline, color: whiteColor),
                  ],
                ),
                Icon(MdiIcons.bookmarkOutline, color: whiteColor),
              ],
            ),
            sizeVer(5),
            Row(
              children: [
                Text(
                  "3",
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                sizeHor(5),
                Text(
                  "likes",
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Username",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                sizeHor(10),
                Text(
                  "somedisc",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            sizeVer(2),
            Text(
              "view all comments",
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            sizeVer(2),
            Text(
              "08/05/2025",
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openBottomModelSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          decoration: BoxDecoration(color: backGroundColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 4),
                child: Text(
                  "More Options",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: whiteColor,
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: secondaryColor),
              sizeVer(5),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Delete Post",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: whiteColor,
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color: secondaryColor),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                  Navigator.pushNamed(context, PageConst.updatePost);
                  },
                  child: Text(
                    "Update Post",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
