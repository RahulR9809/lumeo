import 'dart:io';

import 'package:equatable/equatable.dart';


class UserEntity extends Equatable{
  final String? uid;
  final String?name;
  final String? username;
  final String? bio;
  final String? link;
  final String? email;
  final String? profileUrl;
   final String? videoUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;

final File? profileImageFile;
final File? videoFile;
  final String? password;
  final String? otherUid;

  const UserEntity( {
 
    this.videoUrl,
    this.videoFile,
    this.profileImageFile,
    this.uid,
   this.name,
    this.username,
    this.bio,
    this.link,
    this.email,
    this.profileUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalFollowing,
    this.password,
    this.otherUid,
    this.totalPosts,
 } );

 @override
 List<Object?>get props=>[
uid,
name,
    username,
    bio,
    link,
    email,
    followers,
    following,
    totalFollowers,
    totalFollowing,
    password,
    otherUid,
    totalPosts,
 profileUrl,
  videoUrl,
profileImageFile,
videoFile,
 ];
}


