import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class GetSingleUserUsecase {

   final FirebaseRepository repository;

  GetSingleUserUsecase({required this.repository});


Stream<List<UserEntity>> call(String uid){
      print("Usecase called with uid: $uid");

  return repository . getSingleUser(uid);
}
} 