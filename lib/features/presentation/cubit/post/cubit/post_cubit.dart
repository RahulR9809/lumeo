import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/read_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUsecase createPostUsecase;
  final DeletePostUsecase deletePostUsecase;
  final LikePostUsecase likePostUsecase;
  final ReadPostUsecase readPostUsecase;
  final UpdatePostUsecase updatePostUsecase;

  PostCubit(
  { required this.createPostUsecase,
   required this.deletePostUsecase,
   required this.likePostUsecase,
   required this.readPostUsecase,
   required this.updatePostUsecase,}
  ) : super(PostInitial());


    Future<void> getPosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      // ignore: non_constant_identifier_names
      final StreamResponse = readPostUsecase.call(post);
      StreamResponse.listen((post) {
        emit(PostLoaded(posts: post));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }



Future<void>likePost({required PostEntity post})async{
  try{
    await likePostUsecase.call(post);
  }on SocketException catch(_){
    emit(PostFailure());
  } catch(e){
emit(PostFailure());
  }
}


Future<void>deletePost({required PostEntity post})async{
  try{
    await deletePostUsecase.call(post);
  }on SocketException catch(_){
    emit(PostFailure());
  } catch(e){
emit(PostFailure());
  }
}



Future<void>createPost({required PostEntity post})async{
  try{
    await createPostUsecase.call(post);
  }on SocketException catch(_){
    emit(PostFailure());
  } catch(e){
emit(PostFailure());
  }
}



Future<void>updatePost({required PostEntity post})async{
  try{
    await updatePostUsecase.call(post);
  }on SocketException catch(_){
    emit(PostFailure());
  } catch(e){
emit(PostFailure());
  }
}


}
