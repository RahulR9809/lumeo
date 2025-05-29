import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/post/widget/like_animation_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostDetailMainWidget extends StatefulWidget {
  final String? postId;
  const PostDetailMainWidget({super.key, this.postId});

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {

 bool _isLikeAnimating = false;
  String? _currentUid;
  @override
  void initState() {
    super.initState();
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
     BlocProvider.of<GetSinglePostCubit>(context).getSinglePost(postId: widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Post Detail"),
      ),
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
        builder: (context, getSinglePostState) {
          if(getSinglePostState is GetSinglePostLoaded){
            final singlePost=getSinglePostState.post;
return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
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
                            child: profilewidget(
                              imageUrl: "${singlePost.userProfileUrl}",
                            ),
                          ),
                        ),
                        sizeHor(10),
                        Text(
                          "${singlePost.userName}",
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    singlePost.creatorUid == _currentUid
                        ? GestureDetector(
                          onTap: () {
                            _openBottomModelSheet(context, singlePost);
                          },
                          child: Icon(Icons.more_vert, color: whiteColor),
                        )
                        : SizedBox(height: 0, width: 0),
                  ],
                ),
                sizeVer(10),
                GestureDetector(
                  onDoubleTap: () {
                    _likePost();
                    setState(() {
                      _isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: profilewidget(
                          imageUrl: "${singlePost.postImageUrl}",
                        ),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _isLikeAnimating ? 1 : 0,
                        child: LikeAnimationWidget(
                          duration: Duration(milliseconds: 300),
                          isLikeAnimating: _isLikeAnimating,
                          onLikeFinish: () {
                            setState(() {
                              _isLikeAnimating = false;
                            });
                          },
                          child: Icon(
                            Icons.favorite,
                            size: 100,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sizeVer(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _likePost();
                          },
                          child: Icon(
                            singlePost.likes!.contains(_currentUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 27,
                            color:
                                singlePost.likes!.contains(_currentUid)
                                    ? Colors.red
                                    : whiteColor,
                          ),
                        ),
                        sizeHor(10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PageConst.commentPage,
                              arguments: AppEntites(
                                uid: _currentUid,
                                postId: singlePost.postId,
                              ),
                            );
                          },
                          child: Icon(
                            MdiIcons.commentOutline,
                            color: whiteColor,
                          ),
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
                      "${singlePost.totalLikes}",
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
                      "${singlePost.userName}",
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    sizeHor(10),
                    Text(
                      "${singlePost.description}",
                      style: TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                sizeVer(2),
                Text(
                  "${singlePost.totalComments} comments",
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                sizeVer(2),
                Text(
                  DateFormat(
                    "dd/MM/yyy",
                  ).format(singlePost.createAt!.toDate()),
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
          }
          return  Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }


void _showDeleteConfirmationDialog(BuildContext context, PostEntity post) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: backGroundColor,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade600, width: 1.5),
      ),
      title: Text(
        'Delete Post',
        style: TextStyle(
          color: whiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this post?',
        style: TextStyle(color: whiteColor),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: secondaryColor, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deletePost(creatorUid: post.creatorUid); // Your delete function
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  _openBottomModelSheet(BuildContext context, PostEntity post) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
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
                  onTap: () {
                   _showDeleteConfirmationDialog(context, post);
                  },
                  child: Text(
                    "Delete Post",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
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
                    Navigator.pushNamed(
                      context,
                      PageConst.updatePost,
                      arguments: post,
                    );
                  },
                  child: Text(
                    "Update Post",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
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


    _deletePost({String? creatorUid}) {
    BlocProvider.of<PostCubit>(
      context,
    ).deletePost(post: PostEntity(postId: widget.postId, creatorUid:creatorUid ));
  }

  void _likePost() {
    BlocProvider.of<PostCubit>(
      context,
    ).likePost(post: PostEntity(postId: widget.postId));
  }



}
