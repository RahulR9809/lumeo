
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class GetCurrentUuidUsecase {
  final FirebaseRepository repository;
  GetCurrentUuidUsecase({required this.repository});

  Future<String> call() {
    {
      return repository.getCurrentUid();
    }
  }
}
