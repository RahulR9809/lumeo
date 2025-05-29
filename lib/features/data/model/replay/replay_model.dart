import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';

class ReplayModel extends ReplayEntity {
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
  final String? replayId;

   ReplayModel({
    this.commentId,
    this.postId,
    this.creatorUid,
    this.description,
    this.username,
    this.userProfileUrl,
    this.createAt,
    this.likes,
    this.replayId,
  }) : super(
         commentId: commentId,
         postId: postId,
         creatorUid: creatorUid,
         description: description,
         username: username,
         userProfileUrl: userProfileUrl,
         createAt: createAt,
         likes: likes,
         replayId: replayId
       );

        factory ReplayModel.fromSnapshot(DocumentSnapshot snap){
    var snapshot=snap.data()as Map<String,dynamic>;
    return ReplayModel(
      commentId: snapshot['commentId'],
      postId: snapshot['postId'],
       creatorUid: snapshot['creatorUid'],
      username: snapshot['username'],
      description: snapshot['description'],
      userProfileUrl: snapshot['userProfileUrl'],
      createAt: snapshot['createAt'],
      likes: List.from(snap.get('likes')),
      replayId: snapshot['replayId'],
      
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
        "replayId": replayId,
        "createAt": createAt,
  };

}
