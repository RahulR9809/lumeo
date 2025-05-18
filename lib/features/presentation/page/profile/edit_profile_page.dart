import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/page/profile/widgets/profile_form_widget.dart';
import 'package:lumeo/widget_profile.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;
  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController = TextEditingController();
  TextEditingController? _userNameController = TextEditingController();
  TextEditingController? _linkController = TextEditingController();
  TextEditingController? _bioController = TextEditingController();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentUser.name);
    _userNameController = TextEditingController(
      text: widget.currentUser.username,
    );
    _linkController = TextEditingController(text: widget.currentUser.link);
    _bioController = TextEditingController(text: widget.currentUser.bio);

    super.initState();
  }

  File? _profileImage;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) {
          _profileImage = File(pickedFile.path);
        } else {
          print('no image has been selected');
        }
      });
    } catch (e) {}
  }

  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text("Edit profile", style: TextStyle(color: whiteColor)),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, color: whiteColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _updateUserProfile,
              child: Icon(Icons.done, color: blueColor),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: ClipOval(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: secondaryColor,
                    ),
                    child:
                        _profileImage == null
                            ? profilewidget(
                              imageUrl: widget.currentUser.profileUrl,
                            )
                            : Image.file(_profileImage!, fit: BoxFit.cover),
                  ),
                ),
              ),
              sizeVer(15),
              Center(
                child: GestureDetector(
                  onTap: () {
                    selectImage();
                  },
                  child: Text(
                    "Change profile image",
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              ProfileFormWidget(title: "Name", controller: _nameController),
              sizeVer(15),
              ProfileFormWidget(
                title: "Username",
                controller: _userNameController,
              ),
              sizeVer(15),
              ProfileFormWidget(title: "Link", controller: _linkController),
              sizeVer(15),
              ProfileFormWidget(title: "Bio", controller: _bioController),
              _isUpdating == true
                  ? Row(
                    children: [
                      Text(
                        "please wait...",
                        style: TextStyle(color: Colors.white),
                      ),
                      sizeVer(10),
                      CircularProgressIndicator(),
                    ],
                  )
                  : SizedBox(width: 0, height: 0),
            ],
          ),
        ),
      ),
    );
  }
  _clear() {
    setState(() {
      _isUpdating == false;
      _userNameController!.clear();
      _nameController!.clear();
      _bioController!.clear();
      _linkController!.clear();
    });
    Navigator.pop(context);
  }

  Future<void> _updateUserProfile() async {
    setState(() => _isUpdating = true);

    final updatedUser = UserEntity(
      uid: widget.currentUser.uid,
      username: _userNameController!.text,
      name: _nameController!.text,
      link: _linkController!.text,
      bio: _bioController!.text,
      profileImageFile: _profileImage,
    );

    BlocProvider.of<UserCubit>(context).updateUser(user: updatedUser).then((_) {
      _clear();
      Navigator.pop(context, updatedUser);
    });
  }
}
