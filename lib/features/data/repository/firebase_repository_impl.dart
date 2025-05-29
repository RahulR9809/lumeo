
import 'dart:io';

import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/entities/saved_post_entity/saved_post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository{
 
final FirebaseRemoteDataSource firebaseRemoteDataSource;
final CloudinaryRepository cloudinaryRepository;

  FirebaseRepositoryImpl({required this.cloudinaryRepository,required this.firebaseRemoteDataSource, });

  // @override
  // Future<void> createUser(UserEntity user)async =>firebaseRemoteDataSource.createUser(user);


@override
Future<void> createUser(UserEntity user) async {
  print("Creating user with UID: ${user.uid}"); // Log the user UID or other details
  try {
    await firebaseRemoteDataSource.createUser(user);
    print("User successfully created with UID: ${user.uid}"); // Log success
  } catch (e) {
    print("Error creating user: $e"); // Log error if any
  }
}



  @override
  Future<String> getCurrentUid()async =>firebaseRemoteDataSource.getCurrentUid();

  @override
  Stream<List<UserEntity>> getSingleUser(String uid)=> firebaseRemoteDataSource.getSingleUser(uid);

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user)=>firebaseRemoteDataSource.getUsers(user);

  @override
  Future<bool> isSignIn()async => firebaseRemoteDataSource.isSignIn();

  @override
  Future<void> loginUser(UserEntity user) async =>firebaseRemoteDataSource.loginUser(user);

  @override
  Future<void> signOut() async => firebaseRemoteDataSource.signOut();

  @override
  Future<void> signUpUser(UserEntity user) async => firebaseRemoteDataSource.signUpUser(user);

  @override
  Future<void> updateUser(UserEntity user)async =>firebaseRemoteDataSource.updateUser(user);


  
  @override
  Future<String> uploadVideoToStorage(File? file)=>
 cloudinaryRepository.uploadVideoToStorage(file);
 
  @override
  Future<String> uploadPostImageToStorage(File? file, String childName)=>
  cloudinaryRepository.uploadPostImageToStorage(file, childName);
 
  @override
  Future<String> uploadProfileImageToStorage(File? file, String childName) =>
  cloudinaryRepository.uploadProfileImageToStorage(file, childName);



  @override
  Future<void> createPost(PostEntity post)async =>firebaseRemoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post)async=>firebaseRemoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post)async =>firebaseRemoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPosts(PostEntity post)=>firebaseRemoteDataSource.readPosts(post);

  @override
  Future<void> updatePost(PostEntity post)async =>firebaseRemoteDataSource.updatePost(post);


//Comments

  @override
  Future<void> createComment(CommentEntity comment)async=>firebaseRemoteDataSource.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment)async=>firebaseRemoteDataSource.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment)async=>firebaseRemoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComments(String postId)=>firebaseRemoteDataSource.readComments(postId);

  @override
  Future<void> updateComment(CommentEntity comment)async=>firebaseRemoteDataSource.updateComment(comment);
  
  @override
  Stream<List<PostEntity>> readSinglePosts(String postId)=>firebaseRemoteDataSource.readSinglePosts(postId);


//replays

  @override
  Future<void> createReplays(ReplayEntity replay)async=>firebaseRemoteDataSource.createReplays(replay);

  @override
  Future<void> deleteReplays(ReplayEntity replay)async=>firebaseRemoteDataSource.deleteReplays(replay);
  
  
  @override
  Future<void> likeReplays(ReplayEntity replay)async=>firebaseRemoteDataSource.likeReplays(replay);

  @override
  Stream<List<ReplayEntity>> readReplays(ReplayEntity replay)=>firebaseRemoteDataSource.readReplays(replay);
  @override
  Future<void> updateReplays(ReplayEntity replay)async=>firebaseRemoteDataSource.updateReplays(replay);
  
  @override
  Future<void> followUnfollowUser(UserEntity user)async=>firebaseRemoteDataSource.followUnfollowUser(user);
  


  @override
  Future<void> savePost(String postId, String userId) =>
      firebaseRemoteDataSource.savePost(postId, userId);

  @override
  Stream<List<SavedpostsEntity>> readsavedPost(String userId) {
    return firebaseRemoteDataSource.readSavedPost(userId);
  }
  
  @override
  Future<void> deleteSavedPost(String postId, String userId)=>firebaseRemoteDataSource.deleteSavedPost(postId, userId);
  
  @override
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid)=>firebaseRemoteDataSource.getSingleOtherUser(otherUid);
  
  @override
  Future<List<PostEntity>> likepage()=>firebaseRemoteDataSource.likepage();



}