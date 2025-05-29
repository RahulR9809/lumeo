import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UpdateReplayUsecase {

   final FirebaseRepository repository;

  UpdateReplayUsecase({required this.repository});


Future<void> call(ReplayEntity replay){
  return repository . updateReplays(replay);
}
} 