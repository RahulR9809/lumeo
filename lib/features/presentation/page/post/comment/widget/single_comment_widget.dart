import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/replay_cubit/replay_cubit.dart';
import 'package:lumeo/features/presentation/page/post/comment/widget/single_replay_widget.dart';
import 'package:lumeo/features/presentation/widgets/form_container_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListner;
  final VoidCallback? onLikeClickListner;
  final UserEntity? currentUser;
  const SingleCommentWidget({
    super.key,
    required this.currentUser,
    required this.comment,
    this.onLongPressListner,
    this.onLikeClickListner,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;
  final TextEditingController _replayDescriptionController = TextEditingController();
  String? _currentUid;
  @override
  void initState() {
    super.initState();
    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    BlocProvider.of<ReplayCubit>(context).getReplays(
      replay: ReplayEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress:widget.comment.creatorUid==_currentUid? widget.onLongPressListner:null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: profilewidget(imageUrl: widget.comment.userProfileUrl),
            ),
          ),
          sizeHor(8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.comment.username}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.onLikeClickListner!();
                        },
                        child: Icon(
                          widget.comment.likes!.contains(_currentUid)
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 27,
                          color:
                              widget.comment.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${widget.comment.description}",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  sizeVer(4),
                  Row(
                    children: [
                      Text(
                        DateFormat("dd/MM/yyy").format(widget.comment.createAt!.toDate()),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      sizeHor(20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isUserReplaying = !_isUserReplaying;
                          });
                        },
                        child: Text(
                          "replay",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      sizeHor(20),
                      GestureDetector(
                        onTap: () {
                          // widget.comment.totalReplays==0? toast('No Replays'):
                          BlocProvider.of<ReplayCubit>(context).getReplays(
                            replay: ReplayEntity(
                              postId: widget.comment.postId,
                              commentId: widget.comment.commentId,
                            ),
                          );
                        },
                        child: Text(
                          "view replays",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<ReplayCubit, ReplayState>(
                    builder: (context, replayState) {
                      if (replayState is ReplayLoading) {
                        Center(child: CircularProgressIndicator());
                      }
                      if (replayState is ReplayLoaded) {
                        final replays =
                            replayState.replays
                                .where(
                                  (element) =>
                                      element.commentId ==
                                      widget.comment.commentId,
                                )
                                .toList();
                        return ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: replays.length,
                          itemBuilder: (context, index) {
                            return SingleReplyWidget(
                              commentEntity: widget.comment,
                              reply: replays[index],
                              onLikeClickListener: () {
                                likeReplay(replays[index]);
                              },

                              onDelete: (replay) {
                                deleteReplay(replay);
                              },
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                  _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                  _isUserReplaying == true
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FormContainerWidget(
                            hintText: "Post Your replay...",
                            controller: _replayDescriptionController,
                          ),
                          sizeVer(10),
                          GestureDetector(
                            onTap: () {
                              _createReplay();
                            },
                            child: Text(
                              "Post",
                              style: TextStyle(color: blueColor),
                            ),
                          ),
                        ],
                      )
                      : SizedBox(width: 0, height: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _createReplay() {
    BlocProvider.of<ReplayCubit>(context)
        .createReplay(
          replay: ReplayEntity(
            replayId: Uuid().v1(),
            createAt: Timestamp.now(),
            likes: [],
            username: widget.currentUser!.username,
            userProfileUrl: widget.currentUser!.profileUrl,
            creatorUid: widget.currentUser!.uid,
            postId: widget.comment.postId,
            commentId: widget.comment.commentId,
            description: _replayDescriptionController.text,
          ),
        )
        .then((value) {
          _clear();
        });
  }

  _clear() {
    _replayDescriptionController.clear();
    _isUserReplaying = false;
  }

  void likeReplay(ReplayEntity replay) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(
      replay: ReplayEntity(
        postId: replay.postId,
        commentId: replay.commentId,
        replayId: replay.replayId,
      ),
    );
  }

  void deleteReplay(ReplayEntity replay) {
    BlocProvider.of<ReplayCubit>(context).deleteReplay(
      replay: ReplayEntity(
        postId: replay.postId,
        commentId: replay.commentId,
        replayId: replay.replayId,
      ),
    );
  }
}
