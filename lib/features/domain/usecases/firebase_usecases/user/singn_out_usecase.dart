import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class SingnOutUsecase {

   final FirebaseRepository repository;

  SingnOutUsecase({required this.repository});


Future<void> call(){
  return repository .signOut();
}
} 