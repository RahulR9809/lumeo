import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class IsLoggedInUsecase {

   final FirebaseRepository repository;

  IsLoggedInUsecase({required this.repository});


Future<bool> call(){
  print('usercase');
  return repository .isSignIn();
}
} 