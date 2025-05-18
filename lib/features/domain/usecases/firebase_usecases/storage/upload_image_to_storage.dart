import 'dart:io';

import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UploadProfileImageToStorageUseCase {

   final FirebaseRepository repository;

  UploadProfileImageToStorageUseCase({required this.repository});


Future<String> call(File file,String childName){
  return repository . uploadProfileImageToStorage(file, childName);
}
} 