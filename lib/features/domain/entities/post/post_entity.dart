import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String? postId;
  final String? creatorUid;
  final String? userName;
  final String? description;
  final String? postImageUrl;
  final List<String>? likes;
  final num? totalLikes;
  final num? totalComments;
  final Timestamp? createAt;
  final String? userProfileUrl;
  

  final File? postImage;
  final String? postUrl;


 const PostEntity(
 {
  this.postUrl,
       this.postImage,
     this.postId,
    this.creatorUid,
    this.userName,
    this.description,
    this.postImageUrl,
    this.likes,
    this.totalLikes,
    this.totalComments,
    this.createAt,
    this.userProfileUrl,}
  );

  @override
  List<Object?> get props => [
     postId,
    creatorUid,
    userName,
    description,
    postImageUrl,
    likes,
    totalLikes,
    totalComments,
    createAt,
    userProfileUrl,
      postImage,
      postUrl

  ];
}
