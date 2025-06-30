import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
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
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.primary,
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.surface),
      ),
      centerTitle: true,
      title: Text("Comments", style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: width * 0.05)),
    ),
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
      child: BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, singleUserState) {
          if (singleUserState is GetSingleUserLoaded) {
            final singeluser = singleUserState.user;

            return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
              builder: (context, singlePostState) {
                if (singlePostState is GetSinglePostLoaded) {
                  final singlePost = singlePostState.post;

                  return BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, commentState) {
                      if (commentState is CommentLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.13,
                                  height: width * 0.13,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(width * 0.065),
                                    child: profilewidget(imageUrl: singlePost.userProfileUrl),
                                  ),
                                ),
                                sizeHor(width * 0.03),
                                Text(
                                  "${singlePost.userName}",
                                  style: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ],
                            ),
                            sizeVer(height * 0.01),
                            Text(
                              "${singlePost.description}",
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            sizeVer(height * 0.02),
                            Divider(thickness: 1, color: Theme.of(context).colorScheme.secondary),
                            sizeVer(height * 0.015),
                            Expanded(
                              child: ListView.builder(
                                itemCount: commentState.comments.length,
                                itemBuilder: (context, index) {
                                  final singleComment = commentState.comments[index];
                                  return SingleCommentWidget(
                                    currentUser: singeluser,
                                    comment: singleComment,
                                    onLongPressListner: () {
                                      _openBottomModelSheet(
                                        context,
                                        singleComment,
                                        widget.appEntites.postId!,
                                      );
                                    },
                                    onLikeClickListner: () {
                                      _LikeComment(singleComment);
                                    },
                                  );
                                },
                              ),
                            ),
                            _commentSection(currentUser: singeluser, width: width, height: height),
                          ],
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    ),
  );
}

  Widget _commentSection({required UserEntity currentUser, required double width, required double height}) {
  return Container(
    width: double.infinity,
    height: height * 0.065,
    margin: EdgeInsets.symmetric(horizontal: width * 0.01),
    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        sizeHor(width * 0.02),
        Expanded(
          child: TextFormField(
            controller: _commentController,
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Post your comment...",
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: width * 0.035),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _createComment(currentUser);
          },
          child: Text(
            "Post",
            style: TextStyle(fontSize: width * 0.04, color: blueColor),
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
                    fontSize: 18,
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
                    _deleteComment(comment.commentId!, postId);
                  },
                  child: Text(
                    "Delete Comment",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
