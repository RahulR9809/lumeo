import 'dart:io';

import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRepository {
  //credential
  Future<void> loginUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

//user
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();

    Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);


//cloud storage

  Future<String>uploadPostImageToStorage(File? file, String childName);
    Future<String>uploadProfileImageToStorage(File? file, String childName);

  Future<String>uploadVideoToStorage(File? file,);

//post
  Future<void> createPost(PostEntity post);
    Stream<List<PostEntity>> readPosts(PostEntity post);
  Future<void> updatePost(PostEntity post);
    Future<void> deletePost(PostEntity post);
        Future<void> likePost(PostEntity post);

}

