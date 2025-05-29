import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/post/widget/like_animation_widget.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
  const SinglePostCardWidget({super.key, required this.post});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  bool _isLikeAnimating = false;
  String? _currentUid;
  @override
  void initState() {
    super.initState();
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
      context.read<BookmarkCubit>().loadBookmarks(value);
    });
    BlocProvider.of<BookmarkCubit>(context).isBookmarked(widget.post.postId!);
  }

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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageConst.singleProfilePage,
                    arguments: widget.post.creatorUid,
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: profilewidget(
                          imageUrl: "${widget.post.userProfileUrl}",
                        ),
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
              ),
              widget.post.creatorUid == _currentUid
                  ? GestureDetector(
                    onTap: () {
                      _openBottomModelSheet(context, widget.post);
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
                  child: profilewidget(imageUrl: "${widget.post.postImageUrl}"),
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
                    child: Icon(Icons.favorite, size: 100, color: Colors.red),
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
                      widget.post.likes!.contains(_currentUid)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      size: 27,
                      color:
                          widget.post.likes!.contains(_currentUid)
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
                          postId: widget.post.postId,
                        ),
                      );
                    },
                    child: Icon(MdiIcons.commentOutline, color: whiteColor),
                  ),
                  sizeHor(10),
                  Icon(MdiIcons.sendOutline, color: whiteColor),
                ],
              ),
              BlocBuilder<BookmarkCubit, Set<String>>(
                builder: (context, bookmarkedPosts) {
                  final isBookmarked = bookmarkedPosts.contains(
                    widget.post.postId,
                  );

                  return GestureDetector(
                    onTap: () async {
                      final cubit = context.read<BookmarkCubit>();
                      cubit.toggleBookmark(widget.post.postId!);

                      if (cubit.isBookmarked(widget.post.postId!)) {
                        await BlocProvider.of<PostCubit>(
                          context,
                        ).savePostUsecase(widget.post.postId!, _currentUid!);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Post saved")));
                      } else {
                        // Implement delete logic
                        await BlocProvider.of<PostCubit>(
                          context,
                        ).deleteSavedPostUsecase(
                          widget.post.postId!,
                          _currentUid!,
                        );
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Post removed")));
                      }
                    },

                    child: Icon(
                      Icons.bookmark,
                      color: isBookmarked ? blueColor : secondaryColor,
                    ),
                  );
                },
              ),
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
            DateFormat("dd/MM/yyy").format(widget.post.createAt!.toDate()),
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, PostEntity post) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: backGroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade600, width: 1.5),
            ),
            title: Text(
              'Delete Post',
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
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
                      _deletePost(); // Your delete function
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

  _deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(
      post: PostEntity(
        postId: widget.post.postId,
        creatorUid: widget.post.creatorUid,
      ),
    );
  }

  void _likePost() {
    BlocProvider.of<PostCubit>(
      context,
    ).likePost(post: PostEntity(postId: widget.post.postId));
  }
}
