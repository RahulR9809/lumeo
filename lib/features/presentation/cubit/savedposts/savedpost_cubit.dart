import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/read_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/savedposts/read_savedpost_usecase.dart';
import 'package:lumeo/features/presentation/cubit/savedposts/savedpost_state.dart';

class SavedpostCubit extends Cubit<SavedpostState> {
  ReadSavedpostUsecase readSavedpostUsecase;
  ReadPostUsecase readPostUsecase;
  SavedpostCubit(
      {required this.readSavedpostUsecase, required this.readPostUsecase})
      : super(SavedPostInitial());

  Future<void> getSavedPost({required String userId}) async {
    emit(SavedPostLoading());

    try {
      final savedPostStream = readSavedpostUsecase.call(userId);

      await for (final savedPosts in savedPostStream) {
        if (savedPosts.isEmpty) {
          emit(SavedPostLoaded(posts: [])); 
          return;
        }

        final savedPostIds = savedPosts.map((post) => post.postId).toList();

        final postStream = readPostUsecase.call(PostEntity());
        final allPosts = await postStream.first;

        final savedPostDetails = allPosts
            .where((post) => savedPostIds.contains(post.postId))
            .toList();

        emit(SavedPostLoaded(posts: savedPostDetails));
      }
    } on SocketException catch (_) {
      emit(SavedPostFailure());
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(SavedPostFailure());
    }
  }
}
