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

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _initializeVideo(File(pickedFile.path));
    }
  }

  Future<void> _recordVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      _initializeVideo(File(pickedFile.path));
    }
  }

  void _initializeVideo(File videoFile) {
    _disposeVideoController();
    _videoController = VideoPlayerController.file(videoFile)
      ..initialize().then((_) {
        setState(() {
          _selectedVideo = videoFile;
          _selectedImages.clear();
        });
        _videoController!.setLooping(true);
        _videoController!.play();
      });
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Post",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            child:
                _selectedImages.isEmpty && _selectedVideo == null
                    ? Center(
                      child: GestureDetector(
                        onTap: _showMediaOptions,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.upload,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    )
                    : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_selectedVideo != null &&
                              _videoController != null)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.5,
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
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: _deleteVideo,
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_selectedImages.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 58,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImages.first,
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _deleteImage(0),
                                      child: const CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TextField(
                              controller: _captionController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Write a caption...",
                                hintStyle: TextStyle(color: whiteColor),
                                filled: true,
                                fillColor: backGroundColor,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.7),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              maxLines: null,
                            ),
                          ),
                          sizeVer(10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreyColor,
                            ),
                            onPressed: () {
                              _createSubmitPost(context);
                            },
                            child: Text(
                              "post",
                              style: TextStyle(color: whiteColor),
                            ),
                          ),
                          sizeVer(20),
                          _uploading==true? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Uploading...",
                                style: TextStyle(color: whiteColor),
                              ),
                            sizeHor(10),
                            CircularProgressIndicator()
                            ],
                          ):SizedBox(height: 0,width: 0,)
                        ],
                      ),
                    ),
          ),
          const SizedBox(height: 12),
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
            color: primaryColor,
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
              const Divider(color: Colors.grey),
              _buildOption(
                icon: Icons.video_library,
                text: "Choose Video from Gallery",
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo();
                },
              ),
              const Divider(color: Colors.grey),
              _buildOption(
                icon: Icons.videocam,
                text: "Record a Video",
                onTap: () {
                  Navigator.pop(context);
                  _recordVideo();
                },
              ),
              const Divider(color: Colors.grey),
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
            Icon(icon, color: isCancel ? Colors.red : Colors.white, size: 28),
            const SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: isCancel ? Colors.red : Colors.white,
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
       _uploading=true;
    });
    BlocProvider.of<PostCubit>(context).createPost(
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
    ).then((value)=>_clear());
  }
  
  _clear() {
    _captionController.clear();
    _selectedImages.clear();
    setState(() {
      _uploading=false;
    });
  }
}
