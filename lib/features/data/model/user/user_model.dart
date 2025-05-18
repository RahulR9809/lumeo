import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  @override
  final String? uid;
  @override
  final String? username;
  @override
  final String? bio;
  @override
  final String? link;
  @override
  final String? email;
  @override
  final String? profileUrl;

  @override
  final String? videoUrl;

  @override
  final List? followers;
  @override
  final List? following;
  @override
  final num? totalFollowers;
  @override
  final num? totalfollowing;
  @override
  final num? totalPost;
  @override
  final String? name;

  const UserModel({
    this.uid,
    this.username,
    this.bio,
    this.link,
    this.email,
    this.profileUrl,
    this.videoUrl,
    this.followers,
    this.following,
    this.totalFollowers,
    this.totalfollowing,
    this.name,
    this.totalPost,
  }) : super(
         uid: uid,
         totalfollowing: totalfollowing,
         followers: followers,
         totalFollowers: totalFollowers,
         username: username,
         profileUrl: profileUrl,
         videoUrl: videoUrl,
         link: link,
         following: following,
         bio: bio,
         name: name,
         email: email,
         totalPost: totalPost,
       );
  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'],
      name: snapshot['name'],
      bio: snapshot['bio'],
      totalFollowers: snapshot['totalFollower'],
      totalfollowing: snapshot['toalFollowing'],
      username: snapshot['username'],
      totalPost: snapshot['totalpost'],
      uid: snapshot['uid'],
      link: snapshot['link'],
      profileUrl: snapshot['profileUrl'],
videoUrl: snapshot['videoUrl'],
      followers: List.from(snap.get("followers")),
      following: List.from(snap.get("following")),
    );
  }
 Map<String,dynamic> toJson()=>{
"uid":uid,
"username":username,
"bio":bio,
"link":link,
"email":email,
"profileUrl":profileUrl,
"videoUrl":videoUrl,
"followers":followers,
"following":following,
"totalFollowers":totalFollowers,
"totalfollowing":totalfollowing,
"totalPost":totalPost,
"name":name,
 };
}
