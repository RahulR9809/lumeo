import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/delete_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/read_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CreateCommentUsecase createCommentUsecase;
  final DeleteCommentUsecase deleteCommentUsecase;
  final LikeCommentUsecase likeCommentUsecase;
  final ReadCommentUsecase readCommentUsecase;
  final UpdateCommentUsecase updateCommentUsecase;
  CommentCubit({
    required this.createCommentUsecase,
    required this.deleteCommentUsecase,
    required this.likeCommentUsecase,
    required this.readCommentUsecase,
    required this.updateCommentUsecase,
  }) : super(CommentInitial());



Future<void>createComment({required CommentEntity comment})async{
  try{
    await createCommentUsecase.call(comment);
  }on SocketException catch(_){
    emit(CommentFailure());
  } catch(e){
emit(CommentFailure());
  }
}




     Future<void> getComments({required String postId}) async {
    emit(CommentLoading());
    try {
      // ignore: non_constant_identifier_names
      final StreamResponse = readCommentUsecase.call(postId);
      StreamResponse.listen((comments) {
        emit(CommentLoaded(comments: comments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }



Future<void>likeComment({required CommentEntity comment})async{
  try{
    await likeCommentUsecase.call(comment);
  }on SocketException catch(_){
    emit(CommentFailure());
  } catch(e){
    print(e);
emit(CommentFailure());
  }
}


Future<void>updateComment({required CommentEntity comment})async{
  try{
    await updateCommentUsecase.call(comment);
  }on SocketException catch(_){
    emit(CommentFailure());
  } catch(e){
emit(CommentFailure());
  }
}



Future<void>deleteComment({required CommentEntity comment})async{
  try{
    await deleteCommentUsecase.call(comment);
  }on SocketException catch(_){
    emit(CommentFailure());
  } catch(e){
emit(CommentFailure());
  }
}



}
