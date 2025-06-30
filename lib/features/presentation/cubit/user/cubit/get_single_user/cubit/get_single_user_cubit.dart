import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  GetSingleUserCubit({required this.getSingleUserUsecase})
    : super(GetSingleUserInitial());

    
  Future<void> getSingleUser({required String uid}) async {
  emit(GetSingleUserLoading());
  
  try {
    final streamResponse = getSingleUserUsecase.call(uid);
    streamResponse.listen(
      (users) {
        if (users.isNotEmpty) {
          emit(GetSingleUserLoaded(user: users.first));
        } else {
          emit(GetSingleUserFailure());
        }
      },
      onError: (error) {
        emit(GetSingleUserFailure());
      },
      onDone: () {
        if (kDebugMode) {
          print('Stream closed');
        }
      },
      cancelOnError: true,
    );
  } on SocketException catch (_) {
    if (kDebugMode) {
      print('SocketException occurred');
    }
    emit(GetSingleUserFailure());
  } catch (e) {
    if (kDebugMode) {
      print('Exception occurred: $e');
    }
    emit(GetSingleUserFailure());
  }
}

}
