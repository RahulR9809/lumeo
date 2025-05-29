import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/replay_cubit/replay_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/page/post/comment/widget/single_comment_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:uuid/uuid.dart';

class CommentPage extends StatefulWidget {
  final AppEntites appEntites;
  const CommentPage({super.key, required this.appEntites});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isUserReplaying = false;
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(
      context,
    ).getSingleUser(uid: widget.appEntites.uid!);

 BlocProvider.of<GetSinglePostCubit>(
      context,
    ).getSinglePost(postId: widget.appEntites.postId!);

    BlocProvider.of<CommentCubit>(
      context,
    ).getComments(postId: widget.appEntites.postId!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: whiteColor),
        ),
        centerTitle: true,
        title: Text("Comments", style: TextStyle(color: whiteColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
          builder: (context, singleUserState) {
            if (singleUserState is GetSingleUserLoaded) {
              final singeluser = singleUserState.user;
              return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
                builder: (context,singlePostState) {
                  if(singlePostState is GetSinglePostLoaded){
                    final singlePost=singlePostState.post;
 return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                 child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: 
                                  profilewidget(imageUrl: singlePost.userProfileUrl),
                                 ),
                                ),
                                sizeHor(10),
                                Text(
                                  "${singlePost.userName}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                            sizeVer(10),
                            Text(
                              "${singlePost.description}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                              ),
                            ),
                            sizeVer(10),
                            Divider(thickness: 1, color: secondaryColor),
                            sizeVer(10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: commentState.comments.length,
                                itemBuilder: (context, index) {
                                  final singlComment =
                                      commentState.comments[index];
                                  return SingleCommentWidget(
                                    currentUser: singeluser,
                                    comment: singlComment,
                                    onLongPressListner: () {
                                      _openBottomModelSheet(
                                        context,
                                        commentState.comments[index],
                                        widget.appEntites.postId!,
                                      );
                                    },
                                    onLikeClickListner: () {
                                      _LikeComment(
                                        commentState.comments[index],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            _commentSection(currentUser: singeluser),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                  }
                             return Center(child: CircularProgressIndicator());

                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  _commentSection({required UserEntity currentUser}) {
    return Container(
      width: double.infinity,
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: darkGreyColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          sizeHor(10),
          Expanded(
            child: TextFormField(
              controller: _commentController,
              style: TextStyle(color: whiteColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Post your comment...",
                hintStyle: TextStyle(color: whiteColor),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _createComment(currentUser);
            },
            child: Text(
              "Post",
              style: TextStyle(fontSize: 15, color: blueColor),
            ),
          ),
        ],
      ),
    );
  }

  _createComment(UserEntity currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
          comment: CommentEntity(
            totalReplays: 0,
            commentId: Uuid().v1(),
            createAt: Timestamp.now(),
            likes: [],
            username: currentUser.username,
            description: _commentController.text,
            creatorUid: currentUser.uid,
            postId: widget.appEntites.postId,
            userProfileUrl: currentUser.profileUrl,
          ),
        )
        .then((value) {
          _commentController.clear();
        });
  }

  _openBottomModelSheet(
    BuildContext context,
    CommentEntity comment,
    String postId,
  ) {
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
                    _deleteComment(comment.commentId!, postId);
                  },
                  child: Text(
                    "Delete Comment",
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
                    Navigator.pushNamed(
                      context,
                      PageConst.updateCommentPage,
                      arguments: comment,
                    );
                  },
                  child: Text(
                    "Update Comment",
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

  void _deleteComment(String commentId, String postId) {
    BlocProvider.of<CommentCubit>(context).deleteComment(
      comment: CommentEntity(commentId: commentId, postId: postId),
    );
  }

  void _LikeComment(CommentEntity comment) {
    BlocProvider.of<CommentCubit>(context).likeComment(
      comment: CommentEntity(
        postId: comment.postId,
        commentId: comment.commentId,
      ),
    );
  }
  
}
