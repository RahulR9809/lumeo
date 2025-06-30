import 'package:flutter/foundation.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class GetSingleOtherUsecase {

   final FirebaseRepository repository;

  GetSingleOtherUsecase({required this.repository});


Stream<List<UserEntity>> call(String otherUid){
      if (kDebugMode) {
        print("Usecase called with uid: $otherUid");
      }

  return repository . getSingleOtherUser(otherUid);
}
} 