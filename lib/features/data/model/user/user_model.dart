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
  final num? totalFollowing;
  @override
  final num? totalPosts;
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
    this.totalFollowing,
    this.name,
    this.totalPosts,
  }) : super(
         uid: uid,
         totalFollowing: totalFollowing,
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
         totalPosts: totalPosts,
       );
  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'],
      name: snapshot['name'],
      bio: snapshot['bio'],
      totalFollowers: snapshot['totalFollowers']??0,
      totalFollowing: snapshot['totalFollowing']??0,
      username: snapshot['username'],
      totalPosts: snapshot['totalPosts'],
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
"totalFollowing":totalFollowing,
"totalPosts":totalPosts,
"name":name,
 };
}
