import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/page/profile/widgets/profile_form_widget.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';

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
      // ignore: invalid_use_of_visible_for_testing_member
      final pickedFile = await ImagePicker.platform.getImageFromSource(
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) {
          _profileImage = File(pickedFile.path);
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
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.primary,
    appBar: AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        "Edit profile",
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
          fontSize: width * 0.05,
        ),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.close, color: Theme.of(context).colorScheme.surface, size: width * 0.06),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: width * 0.03),
          child: GestureDetector(
            onTap: _updateUserProfile,
            child: Icon(Icons.done, color: blueColor, size: width * 0.065),
          ),
        ),
      ],
    ),
    body: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.015,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ClipOval(
                child: Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 0.15),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: _profileImage == null
                      ? profilewidget(imageUrl: widget.currentUser.profileUrl)
                      : Image.file(_profileImage!, fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: height * 0.015),
            Center(
              child: GestureDetector(
                onTap: selectImage,
                child: Text(
                  "Change profile image",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            ProfileFormWidget(
              title: "Name",
              controller: _nameController,
            ),
            SizedBox(height: height * 0.02),
            ProfileFormWidget(
              title: "Username",
              controller: _userNameController,
            ),
            SizedBox(height: height * 0.02),
            ProfileFormWidget(
              title: "Link",
              controller: _linkController,
            ),
            SizedBox(height: height * 0.02),
            ProfileFormWidget(
              title: "Bio",
              controller: _bioController,
            ),
            SizedBox(height: height * 0.02),
            _isUpdating
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Please wait...",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surface,
                          fontSize: width * 0.04,
                        ),
                      ),
                      SizedBox(width: width * 0.03),
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
