
import 'dart:io';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';

class UploadVideoToStorageUseCase {
  final FirebaseRepository repository;

  UploadVideoToStorageUseCase({required this.repository});
  
   Future<String> call(File file){
return repository.uploadVideoToStorage(file);
   }
}