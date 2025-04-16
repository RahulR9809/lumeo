import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class GetUsersUsecase {

   final FirebaseRepository repository;

  GetUsersUsecase({required this.repository});


Stream<List<UserEntity>> call(UserEntity userentity){
  return repository . getUsers(userentity);
}
} 