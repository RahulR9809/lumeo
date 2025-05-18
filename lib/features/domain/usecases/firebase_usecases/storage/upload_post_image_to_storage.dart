import 'dart:io';

import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UploadPostImageToStorage {
  final FirebaseRepository repository;

  UploadPostImageToStorage({required this.repository});
  Future<String>call(File file,String childName){
    return repository.uploadPostImageToStorage(file, childName);
  }
}