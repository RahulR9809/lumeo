import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class DeleteCommentUsecase {

   final FirebaseRepository repository;

  DeleteCommentUsecase({required this.repository});


Future<void> call(CommentEntity comment){
  return repository . deleteComment(comment);
}
} 