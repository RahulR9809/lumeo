import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UpdatePostUsecase{

   final FirebaseRepository repository;

  UpdatePostUsecase({required this.repository});


Future<void> call(PostEntity post){
  return repository . updatePost(post);
}
} 