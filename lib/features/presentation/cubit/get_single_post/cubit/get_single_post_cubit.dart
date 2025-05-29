import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/read_single_post_usecase.dart';

part 'get_single_post_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
  final ReadSinglePostUsecase readSinglePostUsecase;
  GetSinglePostCubit({required this.readSinglePostUsecase}) : super(GetSinglePostInitial());


  Future<void> getSinglePost({required String postId}) async {
  emit(GetSinglePostLoading());
  print('State: GetSingleUserLoading');
  
  try {
    print('Entered try block');
    final streamResponse = readSinglePostUsecase.call(postId);
print(streamResponse);
    streamResponse.listen(
      (users) {
        print('Stream emitted: $users');
        if (users.isNotEmpty) {
          print('State: GetSingleUserLoaded');
          emit(GetSinglePostLoaded(post: users.first));
        } else {
          print('Stream emitted empty list');
          emit(GetSinglePostFailure());
        }
      },
      onError: (error) {
        print('Stream error: $error');
        emit(GetSinglePostFailure());
      },
      onDone: () {
        print('Stream closed');
      },
      cancelOnError: true,
    );
  } on SocketException catch (_) {
    print('SocketException occurred');
    emit(GetSinglePostFailure());
  } catch (e) {
    print('Exception occurred: $e');
    emit(GetSinglePostFailure());
  }
}


}
