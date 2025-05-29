import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class LikeCommentUsecase {

   final FirebaseRepository repository;

  LikeCommentUsecase({required this.repository});


Future<void> call(CommentEntity comment){
  return repository . likeComment(comment);
}
} 