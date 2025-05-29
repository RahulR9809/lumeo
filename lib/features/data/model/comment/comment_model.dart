import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';

class CommentModel extends CommentEntity {
  @override
  final String? commentId;
  @override
  final String? postId;
  @override
  final String? creatorUid;
  @override
  final String? description;
  @override
  final String? username;
  @override
  final String? userProfileUrl;
  @override
  final Timestamp? createAt;
  @override
  final List<String>? likes;
  @override
  final num? totalReplays;

  const CommentModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.totalReplays,
  }) : super(
         commentId: commentId,
         postId: postId,
         creatorUid: creatorUid,
         description: description,
         username: username,
         userProfileUrl: userProfileUrl,
         createAt: createAt,
         likes: likes,
         totalReplays: totalReplays
       );

        factory CommentModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot=snap.data()as Map<String,dynamic>;
    return CommentModel(
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
       creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      createAt: snapshot['createAt'],
      likes: List.from(snap.get('likes')),
      totalReplays: snapshot['totalReplays'],
      
    );
  }
  Map<String,dynamic> toJson()=>{
    "postId": postId,
    "commentId":commentId,
        "creatorUid": creatorUid,
        "username": username,
        "description": description,
        "userProfileUrl": userProfileUrl,
        "likes": likes,
        "totalReplays": totalReplays,
        "createAt": createAt,
  };

}
