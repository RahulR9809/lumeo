
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/presentation/cubit/comment/comment_cubit.dart';

class UpdateCommentPage extends StatefulWidget {
  final CommentEntity comment;
  const UpdateCommentPage({required this.comment, super.key});

  @override
  State<UpdateCommentPage> createState() => _UpdateCommentPageState();
}

class _UpdateCommentPageState extends State<UpdateCommentPage> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title:  Text(
          'Edit Comment',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        iconTheme:  IconThemeData(color: Theme.of(context).colorScheme.surface),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : width * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
             Text(
              "Your Comment",
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              style:  TextStyle(color: Theme.of(context).colorScheme.surface),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                hintText: "Edit your comment...",
                hintStyle: TextStyle(color:Theme.of(context).colorScheme.secondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _updateComment,
                icon:  Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
                label:  Text(
                  "Update",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateComment() {
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
          comment: CommentEntity(
            description: _descriptionController.text,
            postId: widget.comment.postId,
            commentId: widget.comment.commentId,
          ),
        )
        .then((_) {
      _descriptionController.clear();
      Navigator.pop(context);
    });
  }
}
