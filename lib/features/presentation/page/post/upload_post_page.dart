import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:lumeo/consts.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key, required this.currentUser});
  final UserEntity currentUser;

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  List<File> _selectedImages = [];
  File? _selectedVideo;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();
  bool _uploading = false;
  Future<void> _pickImages() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages = [File(pickedFile.path)];
        _selectedVideo = null;
        _disposeVideoController();
      });
    }
  }

  // Future<void> _pickVideo() async {
  //   final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     _initializeVideo(File(pickedFile.path));
  //   }
  // }

  // Future<void> _recordVideo() async {
  //   final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     _initializeVideo(File(pickedFile.path));
  //   }
  // }

  // void _initializeVideo(File videoFile) {
  //   _disposeVideoController();
  //   _videoController = VideoPlayerController.file(videoFile)
  //     ..initialize().then((_) {
  //       setState(() {
  //         _selectedVideo = videoFile;
  //         _selectedImages.clear();
  //       });
  //       _videoController!.setLooping(true);
  //       _videoController!.play();
  //     });
  // }

  void _disposeVideoController() {
    _videoController?.dispose();
    _videoController = null;
  }

  void _deleteImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _deleteVideo() {
    setState(() {
      _selectedVideo = null;
      _disposeVideoController();
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    _disposeVideoController();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.primary,

    appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,

      title:  Text(
        "New Post",
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.surface),
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: _selectedImages.isEmpty && _selectedVideo == null
              ? Center(
                  child: GestureDetector(
                    onTap: _showMediaOptions,
                    child: Container(
                      height: height * 0.18,
                      width: height * 0.18,
                      decoration:  BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.upload,
                        color: Theme.of(context).colorScheme.surface,
                        size: width * 0.12,
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedVideo != null && _videoController != null)
                        SizedBox(
                          height: height * 0.5,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_videoController!.value.isPlaying) {
                                    _videoController!.pause();
                                  } else {
                                    _videoController!.play();
                                  }
                                  setState(() {});
                                },
                                child: AspectRatio(
                                  aspectRatio:
                                      _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                ),
                              ),
                              Positioned(
                                top: height * 0.01,
                                right: width * 0.03,
                                child: GestureDetector(
                                  onTap: _deleteVideo,
                                  child: CircleAvatar(
                                    radius: width * 0.035,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: width * 0.035,
                                      color: Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_selectedImages.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.06,
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  _selectedImages.first,
                                  width: double.infinity,
                                  height: height * 0.35,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: height * 0.01,
                                right: width * 0.03,
                                child: GestureDetector(
                                  onTap: () => _deleteImage(0),
                                  child: CircleAvatar(
                                    radius: width * 0.035,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.close,
                                      size: width * 0.035,
                                      color: Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: TextField(
                          controller: _captionController,
                          style:  TextStyle(color: Theme.of(context).colorScheme.surface),
                          decoration: InputDecoration(
                            hintText: "Write a caption...",
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primary,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: height * 0.018,
                              horizontal: width * 0.04,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.surface,
                                width: 1.5,
                              ),
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGreyColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.12,
                            vertical: height * 0.015,
                          ),
                        ),
                        onPressed: () {
                          _createSubmitPost(context);
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontSize: width * 0.045,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.025),
                      _uploading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Uploading...",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                SizedBox(
                                  width: width * 0.05,
                                  height: width * 0.05,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
        ),
        SizedBox(height: height * 0.015),
      ],
    ),
  );
}

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(
                icon: Icons.photo,
                text: "Choose Images from Gallery",
                onTap: () {
                  Navigator.pop(context);
                  _pickImages();
                },
              ),
              // const Divider(color: Colors.grey),
              // _buildOption(
              //   icon: Icons.video_library,
              //   text: "Choose Video from Gallery",
              //   onTap: () {
              //     Navigator.pop(context);
              //     _pickVideo();
              //   },
              // ),
              // const Divider(color: Colors.grey),
              // // _buildOption(
              //   icon: Icons.videocam,
              //   text: "Record a Video",
              //   onTap: () {
              //     Navigator.pop(context);
              //     _recordVideo();
              //   },
              // ),
              // const Divider(color: Colors.grey),
              _buildOption(
                icon: Icons.cancel,
                text: "Cancel",
                isCancel: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isCancel = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: isCancel ? Colors.red : Theme.of(context).colorScheme.surface, size: 28),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: isCancel ? Colors.red : Theme.of(context).colorScheme.surface,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createSubmitPost(BuildContext context) {
    setState(() {
      _uploading = true;
    });
    BlocProvider.of<PostCubit>(context)
        .createPost(
          post: PostEntity(
            description: _captionController.text,
            createAt: Timestamp.now(),
            creatorUid: widget.currentUser.uid,
            likes: [],
            postId: Uuid().v1(),
            postImageUrl: '',
            postImage: _selectedImages[0],
            totalComments: 0,
            totalLikes: 0,
            userName: widget.currentUser.username,
            userProfileUrl: widget.currentUser.profileUrl,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    _captionController.clear();
    _selectedImages.clear();
    setState(() {
      _uploading = false;
    });
  }
}
