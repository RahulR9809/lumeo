
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Edit Comment',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : width * 0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Your Comment",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: "Edit your comment...",
                hintStyle: TextStyle(color: Colors.grey[600]),
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
                icon: const Icon(Icons.check, color: Colors.black),
                label: const Text(
                  "Update",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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
