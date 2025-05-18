
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  //credential
  Future<void> loginUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();
Future<void>createUserWithProfileImage(UserEntity user,String profileUrl);
//user
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();

    Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);

  
//post
  Future<void> createPost(PostEntity post);
    Stream<List<PostEntity>> readPosts(PostEntity post);
  Future<void> updatePost(PostEntity post);
    Future<void> deletePost(PostEntity post);
        Future<void> likePost(PostEntity post);

}

