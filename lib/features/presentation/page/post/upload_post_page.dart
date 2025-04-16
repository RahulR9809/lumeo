// import 'package:flutter/material.dart';
// import 'package:lumeo/consts.dart';

// class UploadPostPage extends StatelessWidget {
//   const UploadPostPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: Center(
//         child: Container(
//           height: 150,
//           width: 150,
//           decoration: BoxDecoration(
//             color: secondaryColor,
//             shape: BoxShape.circle
//           ),
//           child: Icon(Icons.upload,color: whiteColor,size: 50,),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:lumeo/consts.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  List<File> _selectedImages = [];
  File? _selectedVideo;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
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
        title: const Text("New Post", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_selectedImages.isNotEmpty || _selectedVideo != null)
            TextButton(
              onPressed: () {
                // Proceed to post upload
              },
              child: const Text("Post", style: TextStyle(color: Colors.blue, fontSize: 16)),
            ),
        ],
      ),
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Expanded(
            child: _selectedImages.isEmpty && _selectedVideo == null
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
                        child: const Icon(Icons.upload, color: Colors.white, size: 50),
                      ),
                    ),
                  )
                : Column(
                  children: [
                    if (_selectedVideo != null && _videoController != null)
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7, // 70% of screen height
                        child: Stack(
                          children: [
                            // AspectRatio(
                            //   aspectRatio: _videoController!.value.aspectRatio,
                            //   child: VideoPlayer(_videoController!),
                            // ),
                            GestureDetector(
    onTap: () {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      setState(() {}); // Update UI to reflect the change
    },
    child: AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    ),),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _deleteVideo,
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextField(
                          controller: _captionController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Write a caption...",
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ],
                ),

          ),
          if (_selectedImages.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: GestureDetector(
                      onLongPress: () => _deleteImage(index),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImages[index],
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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

  Widget _buildOption({required IconData icon, required String text, required VoidCallback onTap, bool isCancel = false}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: isCancel ? Colors.red : Colors.white, size: 28),
            const SizedBox(width: 15),
            Text(text, style: TextStyle(color: isCancel ? Colors.red : Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
