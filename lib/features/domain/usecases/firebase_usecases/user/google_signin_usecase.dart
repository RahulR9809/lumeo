

import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class GoogleSignInUsecase {
  final FirebaseRepository firebaseRepository;

  GoogleSignInUsecase({required this.firebaseRepository});

  Future<String> call() async {
    return await firebaseRepository.googleSignIn();
  }
}
