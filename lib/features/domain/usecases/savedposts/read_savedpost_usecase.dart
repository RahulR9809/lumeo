
import 'package:lumeo/features/domain/entities/saved_post_entity/saved_post_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class ReadSavedpostUsecase {
  final FirebaseRepository repository;
  ReadSavedpostUsecase({required this.repository});

  Stream<List<SavedpostsEntity>> call(String userId) {
    return repository.readsavedPost(userId);
  }
}