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
  
  try {
    final streamResponse = readSinglePostUsecase.call(postId);
    streamResponse.listen(
      (users) {
        if (users.isNotEmpty) {
          emit(GetSinglePostLoaded(post: users.first));
        } else {
          emit(GetSinglePostFailure());
        }
      },
      onError: (error) {
        emit(GetSinglePostFailure());
      },
      onDone: () {
      },
      cancelOnError: true,
    );
  } on SocketException catch (_) {
    emit(GetSinglePostFailure());
  } catch (e) {
    emit(GetSinglePostFailure());
  }
}


}
