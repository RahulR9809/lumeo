 import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UpdateUserUsecase {

   final FirebaseRepository repository;

  UpdateUserUsecase({required this.repository});


Future<void> call(UserEntity userentity){
  return repository .updateUser(userentity);
}
} 