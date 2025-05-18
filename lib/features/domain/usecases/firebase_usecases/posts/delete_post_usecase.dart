import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class DeletePostUsecase {

   final FirebaseRepository repository;

  DeletePostUsecase({required this.repository});


Future<void> call(PostEntity post){
  return repository . deletePost(post);
}
} 