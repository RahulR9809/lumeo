import 'package:equatable/equatable.dart';


class UserEntity extends Equatable{
  final String? uid;
  final String?name;
  final String? username;
  final String? bio;
  final String? link;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalfollowing;
  final num? totalPost;


  final String? password;
  final String? otherUid;

  const UserEntity({
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
    this.totalfollowing,
    this.password,
    this.otherUid,
    this.totalPost,
 } );

 @override
 List<Object?>get props=>[
uid,
name,
    username,
    bio,
    link,
    email,
    profileUrl,
    followers,
    following,
    totalFollowers,
    totalfollowing,
    password,
    otherUid,
    totalPost,
 ];
}


