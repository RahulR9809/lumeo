import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class LikeReplayUsecase {

   final FirebaseRepository repository;

  LikeReplayUsecase({required this.repository});


Future<void> call(ReplayEntity replay){
  return repository . likeReplays(replay);
}
} 