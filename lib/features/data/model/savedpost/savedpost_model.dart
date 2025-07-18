import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumeo/features/domain/entities/saved_post_entity/saved_post_entity.dart';

class SavedpostModel extends SavedpostsEntity {
  @override
  final String userId;
  @override
  final String postId;
  @override
  final DateTime savedAt;

  SavedpostModel(
      {required this.userId, required this.postId, required this.savedAt}) : super(userId: userId, postId:postId, savedAt: savedAt);

  factory SavedpostModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SavedpostModel(
        userId: snapshot['userId'],
        postId: snapshot['postId'],
        savedAt: (snapshot['savedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() =>
      {"userId": userId, "postId": postId, "savedAt": savedAt};
}
