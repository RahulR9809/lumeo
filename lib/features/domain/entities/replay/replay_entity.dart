import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ReplayEntity extends Equatable {
  //if we want to manipulate replay
  //first post collection -> then specific postid ->
  //then comments -> commentId then ->
  //replay collection ->
  //all the replays of specific comments

  final String? creatorUid;
  final String? replayId;
  final String? commentId;
  final String? postId;
  final String? description;
  final String? username;
  final String? userProfileUrl;
  final List<String>? likes;
  final Timestamp? createAt;

  const ReplayEntity(
  {  this.creatorUid,
    this.replayId,
    this.commentId,
    this.postId,
    this.description,
    this.username,
    this.userProfileUrl,
    this.likes,
    this.createAt,}
  );

  @override
  List<Object?> get props => [
    creatorUid,
    replayId,
    commentId,
    postId,
    description,
    username,
    userProfileUrl,
    likes,
    createAt,];
}
