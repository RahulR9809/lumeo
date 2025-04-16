import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/page/profile/widgets/profile_form_widget.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
            child: Icon(Icons.done, color: blueColor),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: secondaryColor,
                  ),
                ),
              ),
              sizeVer(15),
              Center(
                child: Text(
                  "Change profile image",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              sizeVer(15),
              ProfileFormWidget(title: "Name"),
              sizeVer(15),
              ProfileFormWidget(title: "Username"),
              sizeVer(15),
              ProfileFormWidget(title: "Link"),
              sizeVer(15),
              ProfileFormWidget(title: "Bio"),
            ],
          ),
        ),
      ),
    );
  }
}
