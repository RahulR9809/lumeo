import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class CreateCommentUsecase {

   final FirebaseRepository repository;

  CreateCommentUsecase({required this.repository});


Future<void> call(CommentEntity comment){
  return repository . createComment(comment);
}
} 