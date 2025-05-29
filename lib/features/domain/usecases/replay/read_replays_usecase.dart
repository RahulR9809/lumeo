import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class ReadReplaysUsecase {

   final FirebaseRepository repository;

  ReadReplaysUsecase({required this.repository});


Stream<List<ReplayEntity>> call(ReplayEntity replay){
  return repository . readReplays(replay);
}
} 