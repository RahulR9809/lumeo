
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';

class CloudinaryRepositoryImpl extends CloudinaryRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

// Cloudinary credentials
final String cloudName = 'dlhiwtdp9';

// Separate upload presets
final String profileImageUploadPreset = 'flutter_profile';
final String postImageUploadPreset = 'flutter-post';
final String videoUploadPreset = 'flutter_reel';


  CloudinaryRepositoryImpl({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

@override
Future<String> uploadProfileImageToStorage(File? file, String childName) async {
  if (file == null) throw Exception("File is null");

  final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = profileImageUploadPreset
    ..fields['folder'] = "profilePics/$childName"
    ..files.add(await http.MultipartFile.fromPath('file', file.path));

  final response = await request.send();
  final resStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = json.decode(resStr);
    return data['secure_url'];
  } else {
    throw Exception("Failed to upload profile image: $resStr");
  }
}

@override
Future<String> uploadPostImageToStorage(File? file, String childName) async {
  if (file == null) throw Exception("File is null");

  final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = postImageUploadPreset
    ..fields['folder'] = "posts/$childName"
    ..files.add(await http.MultipartFile.fromPath('file', file.path));

  final response = await request.send();
  final resStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = json.decode(resStr);
    return data['secure_url'];
  } else {
    throw Exception("Failed to upload post image: $resStr");
  }
}

@override
Future<String> uploadVideoToStorage(File? file) async {
  if (file == null) throw Exception("File is null");

  final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/video/upload");

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = videoUploadPreset
    ..fields['folder'] = "profileVideos"
    ..files.add(await http.MultipartFile.fromPath('file', file.path));

  final response = await request.send();
  final resStr = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = json.decode(resStr);
    return data['secure_url'];
  } else {
    throw Exception("Failed to upload video: $resStr");
  }
}

}
