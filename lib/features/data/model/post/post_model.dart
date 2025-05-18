import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';

class PostModel extends PostEntity {
  @override
  final String? postId;

  @override
  final String? creatorUid;
  @override
  final String? userName;
  @override
  final String? description;
  @override
  final String? postImageUrl;
  @override
  final List<String>? likes;
  @override
  final num? totalLikes;
  @override
  final num? totalComments;
  @override
  final Timestamp? createAt;
  @override
  final String? userProfileUrl;


  const PostModel(
{    this.postId,
    this.creatorUid,
    this.userName,
    this.description,
    this.postImageUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,}
  ):super(
      postId: postId,
            creatorUid: creatorUid,
            userName: userName,
            description: description,
            postImageUrl: postImageUrl,
            likes: likes,
            totalLikes: totalLikes,
            totalComments: totalComments,
            createAt: createAt,
            userProfileUrl: userProfileUrl,
            
  );
  factory PostModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot=snap.data()as Map<String,dynamic>;
    return PostModel(postId: snapshot['postId'],
       creatorUid: snapshot['creatorUid'],
      userName: snapshot['userName'],
      description: snapshot['description'],
      postImageUrl: snapshot['postImageUrl'],
      likes: List.from(snap.get('likes')),
      totalLikes: snapshot['totalLikes'],
      totalComments: snapshot['totalComments'],
      createAt: snapshot['createAt'],
      userProfileUrl: snapshot['userProfileUrl'],
    );
  }
  Map<String,dynamic> toJson()=>{
    "postId": postId,
        "creatorUid": creatorUid,
        "userName": userName,
        "description": description,
        "postImageUrl": postImageUrl,
        "likes": likes,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "createAt": createAt,
        "userProfileUrl": userProfileUrl,
  };
}
