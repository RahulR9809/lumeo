import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/page/post/post_detail_page/widget/post_detail_main_widget.dart';
import 'package:lumeo/injection_container.dart' as di;

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
