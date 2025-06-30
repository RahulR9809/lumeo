
import 'package:flutter/foundation.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class FollowUnfollowUsecase {
  final FirebaseRepository repository;
  FollowUnfollowUsecase({required this.repository});

  Future<void> call(UserEntity user) async {
    if (kDebugMode) {
      print('followuser call');
    }
    return repository.followUnfollowUser(user);
  }
}