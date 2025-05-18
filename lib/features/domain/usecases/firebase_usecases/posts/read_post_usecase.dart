import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class ReadPostUsecase {

   final FirebaseRepository repository;

  ReadPostUsecase({required this.repository});


Stream<List<PostEntity>> call(PostEntity post){
  return repository . readPosts(post);
}
} 