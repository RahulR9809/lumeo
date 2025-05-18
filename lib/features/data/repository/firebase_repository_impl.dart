
import 'dart:io';

import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
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
  

}