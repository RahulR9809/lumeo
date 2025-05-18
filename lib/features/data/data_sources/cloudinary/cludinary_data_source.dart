import 'dart:io';

abstract class CloudinaryRepository {
  Future<String> uploadProfileImageToStorage(
    File? file,
    String childName,
  );
    Future<String> uploadPostImageToStorage(
    File? file,
    String childName,
  );
  

  Future<String> uploadVideoToStorage(File? file);
}
