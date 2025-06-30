import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_other_usecase.dart';

part 'get_single_other_user_state.dart';

class GetSingleOtherUserCubit extends Cubit<GetSingleOtherUserState> {
 final GetSingleOtherUsecase getSingleOtherUsecase;
  GetSingleOtherUserCubit({required this.getSingleOtherUsecase}) : super(GetSingleOtherUserInitial());


  Future<void> getSingleOtherUser({required String otherUid}) async {
  emit(GetSingleOtherUserLoading());  
  try {
    final streamResponse = getSingleOtherUsecase.call(otherUid);
    streamResponse.listen(
      (users) {
        if (users.isNotEmpty) {
          emit(GetSingleOtherUserLoaded(otherUser: users.first));
        } else {
          emit(GetSingleOtherUserFailure());
        }
      },
     
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    emit(GetSingleOtherUserFailure());
  }
}



}
