import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/home/widgets/full_screen_widget.dart';
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
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// USER ROW
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(width * 0.1),
                    child: SizedBox(
                      width: width * 0.1,
                      height: width * 0.1,
                      child: profilewidget(
                        imageUrl: widget.post.userProfileUrl ?? "",
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Text(
                    widget.post.userName ?? "",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w800,
                      fontSize: width * 0.04,
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
                    child: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.surface, size: width * 0.06),
                  )
                : SizedBox.shrink(),
          ],
        ),

        SizedBox(height: height * 0.015),

        /// POST IMAGE WITH DOUBLE TAP
        GestureDetector(
          onDoubleTap: () {
            _likePost();
            setState(() {
              _isLikeAnimating = true;
            });
          },
            onLongPress: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenImagePage(imageUrl: widget.post.postImageUrl ?? ''),
      ),
    );
  },
          child: Stack(
            alignment: Alignment.center,
            children: [
             Container(
  width: double.infinity,
  height: height * 0.3,
  decoration: BoxDecoration(
    border: Border.all(
      color: Theme.of(context).colorScheme.secondary,
      width: 2.0,    
    ),
    borderRadius: BorderRadius.circular(36), // Rounded corners
  ),
  child: profilewidget(imageUrl: widget.post.postImageUrl ?? ""),
),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isLikeAnimating ? 1 : 0,
                child: LikeAnimationWidget(
                  duration: const Duration(milliseconds: 300),
                  isLikeAnimating: _isLikeAnimating,
                  onLikeFinish: () {
                    setState(() {
                      _isLikeAnimating = false;
                    });
                  },
                  child: Icon(Icons.favorite, size: width * 0.2, color: Colors.red),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: height * 0.015),

        /// ACTIONS: LIKE, COMMENT, BOOKMARK
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _likePost,
                  child: Icon(
                    widget.post.likes!.contains(_currentUid)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    size: width * 0.07,
                    color: widget.post.likes!.contains(_currentUid)
                        ? Colors.red
                        : Theme.of(context).colorScheme.surface,
                  ),
                ),
                SizedBox(width: width * 0.03),
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
                  child: Icon(MdiIcons.commentOutline, color: Theme.of(context).colorScheme.surface, size: width * 0.065),
                ),
              ],
            ),
            BlocBuilder<BookmarkCubit, Set<String>>(
              builder: (context, bookmarkedPosts) {
                final isBookmarked = bookmarkedPosts.contains(widget.post.postId);
                return GestureDetector(
                  onTap: () async {
                    final cubit = context.read<BookmarkCubit>();
                    cubit.toggleBookmark(widget.post.postId!);

                    if (cubit.isBookmarked(widget.post.postId!)) {
                      await BlocProvider.of<PostCubit>(context)
                          .savePostUsecase(widget.post.postId!, _currentUid!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post saved")),
                      );
                    } else {
                      await BlocProvider.of<PostCubit>(context)
                          .deleteSavedPostUsecase(widget.post.postId!, _currentUid!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post removed")),
                      );
                    }
                  },
                  child: Icon(
                    Icons.bookmark,
                    color: isBookmarked ? blueColor : Theme.of(context).colorScheme.secondary,
                    size: width * 0.065,
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: height * 0.01),

        /// LIKES COUNT
        Row(
          children: [
            Text(
              "${widget.post.totalLikes}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: width * 0.04,
              ),
            ),
            SizedBox(width: width * 0.01),
            Text(
              "likes",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w800,
                fontSize: width * 0.04,
              ),
            ),
          ],
        ),

        /// DESCRIPTION
        Row(
          children: [
            Text(
              widget.post.userName ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.w800,
                fontSize: width * 0.04,
              ),
            ),
            SizedBox(width: width * 0.02),
            Expanded(
              child: Text(
                widget.post.description ?? "",
                style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.037,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: height * 0.005),

        /// COMMENT COUNT
        Text(
          "${widget.post.totalComments} comments",
          style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.035,
          ),
        ),

        SizedBox(height: height * 0.005),

        /// DATE
        Text(
          DateFormat("dd/MM/yyyy").format(widget.post.createAt!.toDate()),
          style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.035,
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
            backgroundColor: Theme.of(context).colorScheme.primary,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade600, width: 1.5),
            ),
            title: Text(
              'Delete Post',
              style: TextStyle(                color: Theme.of(context).colorScheme.secondary,
 fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete this post?',
              style: TextStyle(                color: Theme.of(context).colorScheme.surface,
),
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
                      style: TextStyle(                color: Theme.of(context).colorScheme.secondary,
 fontSize: 16),
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
          decoration: BoxDecoration(color:Theme.of(context).colorScheme.primary,
),
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
              Divider(thickness: 1,                color: Theme.of(context).colorScheme.secondary,
),
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
                                      color: Theme.of(context).colorScheme.surface,

                    ),
                  ),
                ),
              ),
              sizeVer(5),
              Divider(thickness: 1, color:Theme.of(context).colorScheme.secondary,
),
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
