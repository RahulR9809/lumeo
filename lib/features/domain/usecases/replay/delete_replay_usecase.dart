import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class DeleteReplayUsecase {

   final FirebaseRepository repository;

  DeleteReplayUsecase({required this.repository});


Future<void> call(ReplayEntity replay){
  return repository . deleteReplays(replay);
}
} 