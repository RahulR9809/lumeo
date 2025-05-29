import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UpdateCommentUsecase {

   final FirebaseRepository repository;

  UpdateCommentUsecase({required this.repository});


Future<void> call(CommentEntity comment){
  return repository . updateComment(comment);
}
} 