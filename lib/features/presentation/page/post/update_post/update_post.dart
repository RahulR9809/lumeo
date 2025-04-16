import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/page/profile/widgets/profile_form_widget.dart';

class UpdatePost extends StatelessWidget {
  const UpdatePost({super.key});
// TextFormField controller = texfrmfie

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, 
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.arrow_back, color: whiteColor),
        backgroundColor: primaryColor,
        title: Text("Edit Post", style: TextStyle(color: whiteColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:20 ),
            child: Icon(Icons.done,color: blueColor,size:25,),
          )
        ],
      ),
      body: Padding( 
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [ 
              Center(
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              sizeVer(10),
              Text(
                "Username",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeVer(10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(color: secondaryColor),
              ),
              sizeVer(18),
              ProfileFormWidget(
                title: "Discription",
                // controller: ,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
