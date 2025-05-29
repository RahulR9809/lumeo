import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/follow_unfollow_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUsecase updateUserUsecase;
  final GetUsersUsecase getUsersUsecase;
  final FollowUnfollowUsecase followUnfollowUsecase;
  UserCubit( {required this.followUnfollowUsecase,required this.updateUserUsecase, required this.getUsersUsecase})
    : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      // ignore: non_constant_identifier_names
      final StreamResponse = getUsersUsecase.call(user);
      StreamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

Future<void>updateUser({required UserEntity user})async{
  try{
    await updateUserUsecase.call(user);
  }on SocketException catch(_){
    emit(UserFailure());
  } catch(e){
emit(UserFailure());
  }
}


  Future<void> followUser({required UserEntity user}) async {
    try {
      await followUnfollowUsecase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

}
