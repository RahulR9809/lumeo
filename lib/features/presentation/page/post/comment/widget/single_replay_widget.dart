import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/replay_cubit/replay_cubit.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';
import 'package:lumeo/injection_container.dart' as di;

class SingleReplyWidget extends StatefulWidget {
  final ReplayEntity reply;
  final CommentEntity commentEntity;
  final VoidCallback? onLikeClickListener;
  final Function(ReplayEntity)? onDelete; // callback for delete

  const SingleReplyWidget({
    super.key,
    required this.reply,
    this.onLikeClickListener,
    this.onDelete, required this.commentEntity,
  });

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {

  String _currentUid = '';

  @override
  void initState() {
    BlocProvider.of<ReplayCubit>(context).getReplays(
      replay: ReplayEntity(
        postId: widget.reply.postId,
        commentId: widget.reply.commentId,
      ),
    );

    di.sl<GetCurrentUuidUsecase>().call().then((value) {
      _currentUid = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      final isOwner = _currentUid == widget.reply.creatorUid;

    Widget replyContent = buildReplyContent(context);

    return isOwner
        ? Dismissible(
            key: Key(widget.reply.replayId!),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:  Icon(Icons.delete, color: Theme.of(context).colorScheme.surface),
            ),
            confirmDismiss: (direction) async => true,
            onDismissed: (direction) {
              if (widget.onDelete != null) {
                widget.onDelete!(widget.reply);
              }
            },
            child: replyContent,
          )
        : replyContent;
  }

  Widget buildReplyContent(BuildContext context) {
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profilewidget(imageUrl: widget.reply.userProfileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.reply.username ?? ''),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                            widget.reply.likes!.contains(widget.reply.creatorUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 27,
                            color: widget.reply.likes!.contains(widget.reply.creatorUid)
                                ? Colors.red
                                : Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                    Text(widget.reply.description ?? '',style: TextStyle(color: darkGreyColor,fontWeight: FontWeight.bold),),
                    Text(
                      DateFormat("dd/MMM/yyyy").format(widget.reply.createAt!.toDate()),
                      style:  TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize:12,fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
