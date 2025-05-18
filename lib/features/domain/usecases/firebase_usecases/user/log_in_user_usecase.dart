import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class LogInUserUsecase {

   final FirebaseRepository repository;

  LogInUserUsecase({required this.repository});


Future<void> call(UserEntity userentity){
  print('its hereee');
  return repository .loginUser(userentity);
}
} 