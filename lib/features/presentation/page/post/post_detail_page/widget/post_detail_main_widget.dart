import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/home/widgets/full_screen_widget.dart';
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
    BlocProvider.of<GetSinglePostCubit>(
      context,
    ).getSinglePost(postId: widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Post Detail",
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
        builder: (context, getSinglePostState) {
          if (getSinglePostState is GetSinglePostLoaded) {
            final singlePost = getSinglePostState.post;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: height * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.1,
                            height: width * 0.1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(width * 0.05),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    PageConst.singleProfilePage,
                                    arguments: singlePost.creatorUid,
                                  );
                                },
                                child: profilewidget(
                                  imageUrl: singlePost.userProfileUrl ?? "",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.025),
                          Text(
                            singlePost.userName ?? '',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w800,
                              fontSize: width * 0.045,
                            ),
                          ),
                        ],
                      ),
                      singlePost.creatorUid == _currentUid
                          ? GestureDetector(
                            onTap: () {
                              _openBottomModelSheet(context, singlePost);
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).colorScheme.surface,
                              size: width * 0.06,
                            ),
                          )
                          : SizedBox.shrink(),
                    ],
                  ),

                  SizedBox(height: height * 0.015),

                  /// Post image
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
                          builder:
                              (_) => FullScreenImagePage(
                                imageUrl: singlePost.postImageUrl ?? '',
                              ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.3,
                          child: profilewidget(
                            imageUrl: singlePost.postImageUrl ?? '',
                          ),
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
                            child: Icon(
                              Icons.favorite,
                              size: width * 0.2,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// Actions (like/comment/bookmark)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _likePost,
                            child: Icon(
                              singlePost.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: width * 0.07,
                              color:
                                  singlePost.likes!.contains(_currentUid)
                                      ? Colors.red
                                      : Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(width: width * 0.04),
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
                              color: Theme.of(context).colorScheme.surface,
                              size: width * 0.065,
                            ),
                          ),
                        ],
                      ),
                      BlocBuilder<BookmarkCubit, Set<String>>(
                        builder: (context, bookmarkedPosts) {
                          final isBookmarked = bookmarkedPosts.contains(
                            widget.postId,
                          );
                          return GestureDetector(
                            onTap: () async {
                              final cubit = context.read<BookmarkCubit>();
                              cubit.toggleBookmark(widget.postId!);

                              if (cubit.isBookmarked(widget.postId!)) {
                                await BlocProvider.of<PostCubit>(
                                  context,
                                ).savePostUsecase(widget.postId!, _currentUid!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Post saved")),
                                );
                              } else {
                                await BlocProvider.of<PostCubit>(
                                  context,
                                ).deleteSavedPostUsecase(
                                  widget.postId!,
                                  _currentUid!,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Post removed")),
                                );
                              }
                            },
                            child: Icon(
                              Icons.bookmark,
                              color:
                                  isBookmarked
                                      ? blueColor
                                      : Theme.of(context).colorScheme.secondary,
                              size: width * 0.065,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  /// Likes count
                  Row(
                    children: [
                      Text(
                        "${singlePost.totalLikes}",
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

                  SizedBox(height: height * 0.01),

                  /// Description
                  Row(
                    children: [
                      Text(
                        singlePost.userName ?? '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.042,
                        ),
                      ),
                      SizedBox(width: width * 0.025),
                      Expanded(
                        child: Text(
                          singlePost.description ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.04,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  /// Comments count
                  Text(
                    "${singlePost.totalComments} comments",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w800,
                      fontSize: width * 0.038,
                    ),
                  ),

                  SizedBox(height: height * 0.005),

                  /// Date
                  Text(
                    DateFormat(
                      "dd/MM/yyyy",
                    ).format(singlePost.createAt!.toDate()),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.038,
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete this post?',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      _deletePost(
                        creatorUid: post.creatorUid,
                      ); // Your delete function
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
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
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
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.secondary,
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
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.secondary,
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

  _deletePost({String? creatorUid}) {
    BlocProvider.of<PostCubit>(context).deletePost(
      post: PostEntity(postId: widget.postId, creatorUid: creatorUid),
    );
  }

  void _likePost() {
    BlocProvider.of<PostCubit>(
      context,
    ).likePost(post: PostEntity(postId: widget.postId));
  }
}
