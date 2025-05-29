import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class DeleteSavedPostUsecase {
  final FirebaseRepository repository;

  DeleteSavedPostUsecase({required this. repository});

  Future<void> call(String postId, String userId) {
    return repository.deleteSavedPost(postId, userId);
  }
}
