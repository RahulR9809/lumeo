import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/widget_profile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}
class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
 
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: profilewidget(imageUrl: "${widget.post.userProfileUrl}"),
                    ),
                    ),
                    sizeHor(10),
                    Text(
                      "${widget.post.userName}",
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _openBottomModelSheet(context,widget.post);
                  },
                  child: Icon(Icons.more_vert, color: whiteColor),
                ),
              ],
            ),
            sizeVer(10),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.30,
              child: profilewidget(imageUrl: "${widget.post.postImageUrl}"),
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
                  "${widget.post.totalLikes}",
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
                  "${widget.post.userName}",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                sizeHor(10),
                Text(
                  "${widget.post.description}",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            sizeVer(2),
            Text(
              "${widget.post.totalComments} comments",
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            sizeVer(2),
            Text(
              "${DateFormat("dd/MM/yyy").format(widget.post.createAt!.toDate())}",
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
  }
  
  _openBottomModelSheet(BuildContext context,PostEntity post) {
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
                child: GestureDetector(
                  onTap: (){
                    BlocProvider.of<PostCubit>(context).deletePost(post: PostEntity(postId: widget.post.postId,));
                  },
                  child: Text(
                    "Delete Post",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                    Navigator.pushNamed(context, PageConst.updatePost,arguments: post);
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
  }}