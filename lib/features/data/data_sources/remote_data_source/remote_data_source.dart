import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/entities/saved_post_entity/saved_post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  //credential
  Future<void> loginUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<void> createUserWithProfileImage(UserEntity user, String profileUrl);
  //user
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
    Future<void> followUnfollowUser(UserEntity user);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<List<PostEntity>> likepage();


  //post
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePosts(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);
  Future<void> savePost(String postId, String userId);
  Stream<List<SavedpostsEntity>> readSavedPost(String userId);
Future<void> deleteSavedPost(String postId, String userId);
  //comment
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);


      //replay
  Future<void> createReplays(ReplayEntity replay);
    Stream<List<ReplayEntity>> readReplays(ReplayEntity replay);
  Future<void> updateReplays(ReplayEntity replay);
    Future<void> deleteReplays(ReplayEntity replay);
        Future<void> likeReplays(ReplayEntity replay);



}
