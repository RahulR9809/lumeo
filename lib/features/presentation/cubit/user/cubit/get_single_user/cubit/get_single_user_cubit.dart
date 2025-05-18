import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final GetSingleUserUsecase getSingleUserUsecase;
  GetSingleUserCubit({required this.getSingleUserUsecase})
    : super(GetSingleUserInitial());

  // Future<void> getSingleUser({required String uid}) async {
  //   emit(GetSingleUserLoading());
  //   try {
  //     print('its entered');
  //     final streamResponse = getSingleUserUsecase.call(uid);
  //     streamResponse.listen((users) {
  //       emit(GetSingleUserLoaded(user: users.first));
  //       print('this is single user loaded');
  //     });
  //   } on SocketException catch (_) {
  //     emit(GetSingleUserFailure());
  //   } catch (e) {
  //     emit(GetSingleUserFailure());
  //   }
  // }




  Future<void> getSingleUser({required String uid}) async {
  emit(GetSingleUserLoading());
  print('State: GetSingleUserLoading');
  
  try {
    print('Entered try block');
    final streamResponse = getSingleUserUsecase.call(uid);
print(streamResponse);
    streamResponse.listen(
      (users) {
        print('Stream emitted: $users');
        if (users.isNotEmpty) {
          print('State: GetSingleUserLoaded');
          emit(GetSingleUserLoaded(user: users.first));
        } else {
          print('Stream emitted empty list');
          emit(GetSingleUserFailure());
        }
      },
      onError: (error) {
        print('Stream error: $error');
        emit(GetSingleUserFailure());
      },
      onDone: () {
        print('Stream closed');
      },
      cancelOnError: true,
    );
  } on SocketException catch (_) {
    print('SocketException occurred');
    emit(GetSingleUserFailure());
  } catch (e) {
    print('Exception occurred: $e');
    emit(GetSingleUserFailure());
  }
}

}
