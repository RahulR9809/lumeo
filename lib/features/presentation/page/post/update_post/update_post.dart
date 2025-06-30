

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/page/profile/widgets/profile_form_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';

class UpdatePost extends StatefulWidget {
  final PostEntity post;
  const UpdatePost({super.key, required this.post});

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  TextEditingController? _descriptionController;

  @override
  void dispose() {
    _descriptionController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _descriptionController = TextEditingController(
      text: widget.post.description,
    );
    super.initState();
  }

  File? _postImage;

  Future selectImage() async {
    try {
      // ignore: invalid_use_of_visible_for_testing_member
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) {
          _postImage = File(pickedFile.path);
        } else {
          if (kDebugMode) {
            print('no image has been selected');
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  bool _isUpdating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.surface),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Text(
          "Edit Post",
          style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                _updatePost();
              },
              child: Icon(Icons.done, color: Theme.of(context).colorScheme.surface, size: 25),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: darkGreyColor, width: 2),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: profilewidget(
                        imageUrl: "${widget.post.userProfileUrl}",
                      ),
                    ),
                  ),
                ),
              ),
              sizeVer(10),
              Text(
                "${widget.post.userName}",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeVer(10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: darkGreyColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade900,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          _postImage != null
                              ? Image.file(_postImage!, fit: BoxFit.cover)
                              : profilewidget(
                                imageUrl: "${widget.post.postImageUrl}",
                              ),
                    ),
                  ),
                ),
              ),
              sizeVer(18),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: darkGreyColor),
                ),
                child: ProfileFormWidget(
                  title: "Discription",
                  controller: _descriptionController,
                ),
              ),
              sizeVer(20),
              _isUpdating == true
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Updating...", style: TextStyle(color: Theme.of(context).colorScheme.surface)),
                      sizeHor(10),
                      CircularProgressIndicator(),
                    ],
                  )
                  : SizedBox(height: 0, width: 0),
            ],
          ),
        ),
      ),
    );
  }

  _clear() {
    setState(() {
      _isUpdating == false;
      _descriptionController?.clear();
      _postImage = null;
    });
    Navigator.pop(context);
  }

  Future<void> _updatePost() async {
    setState(() => _isUpdating = true);

    final updatePost = PostEntity(
      postImageUrl: '',
      postImage: _postImage,
      postId: widget.post.postId,
      creatorUid: widget.post.creatorUid,
      description: _descriptionController!.text,
    );

    BlocProvider.of<PostCubit>(context).updatePost(post: updatePost).then((_) {
      _clear();
      Navigator.pop(context);
    });
  }
}
