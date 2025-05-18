import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class LikePostUsecase {

   final FirebaseRepository repository;

  LikePostUsecase({required this.repository});


Future<void> call(PostEntity post){
  return repository . likePost(post);
}
} 