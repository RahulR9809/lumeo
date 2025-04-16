import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/presentation/widgets/form_container_widget.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool _isUserReplaying=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: whiteColor),
        ),
        centerTitle: true,
        title: Text("Comments", style: TextStyle(color: whiteColor)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                sizeHor(10),
                Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
              ],
            ),
            sizeVer(10),
            Text(
              "This is very beutiful place",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
            ),
            sizeVer(10),
            Divider(thickness: 1, color: secondaryColor),
            sizeVer(10),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  sizeHor(8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Username",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                ),
                              ),
                              Icon(
                                Icons.favorite_outline,
                                size: 28,
                                color: whiteColor,
                              ),
                            ],
                          ),
                          Text(
                            "this is teh comment",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                          ),
              
                             sizeVer(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "01/2/2025",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkGreyColor,
                      ),
                    ),
                     GestureDetector(
                      onTap: () {
                        setState(() {
                          _isUserReplaying =!_isUserReplaying;
                        });
                      },
                       child: Text(
                        "replay",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGreyColor,
                        ),
                                           ),
                     ),
                     Text(
                      "view replays",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: darkGreyColor,
                      ),
                    ),
                  ],
                ),
                _isUserReplaying==true? sizeVer(10):sizeVer(0),
                _isUserReplaying==true? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  FormContainerWidget(
                    hintText: "Post Your replay..."),
                  sizeVer(10),
                  Text("Post",style: TextStyle(color: blueColor),),
                ],) : Container(width: 0,height: 0,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _commentSection()
          ],
        ),
      ),
    );
  }

  _commentSection() {
  return Container(
    width: double.infinity,
    height: 55,
    margin: EdgeInsets.symmetric(horizontal: 5),
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: darkGreyColor,
      borderRadius: BorderRadius.circular(15),  
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        sizeHor(10),
        Expanded(
          child: TextFormField(
            style: TextStyle(
              color: whiteColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Post your comment...",
              hintStyle: TextStyle(color: whiteColor),
            ),
          ),
        ),
        Text(
          "Post",
          style: TextStyle(fontSize: 15, color: blueColor),
        ),
      ],
    ),
  );
}
}
