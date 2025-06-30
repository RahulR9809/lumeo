import 'package:flutter/material.dart';
import 'package:lumeo/features/presentation/page/post/post_detail_page/widget/post_detail_main_widget.dart';

class PostDetailPage extends StatefulWidget {
  final String? postId;
  const PostDetailPage({super.key, this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return  PostDetailMainWidget(postId: widget.postId,);
    
  }
}
