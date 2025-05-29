import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class ReadCommentUsecase {

   final FirebaseRepository repository;

  ReadCommentUsecase({required this.repository});


Stream<List<CommentEntity>> call(String postId){
  return repository . readComments(postId);
}
} 