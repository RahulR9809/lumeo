import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';

class AppEntites {
  final UserEntity? currentUser;
  final PostEntity? postEntity;



  final String? uid;
  final String? postId;

  AppEntites({this.currentUser, this.postEntity, this.uid, this.postId,});


  
}