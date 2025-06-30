import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:lumeo/features/domain/entities/replay/replay_entity.dart';
import 'package:lumeo/features/domain/usecases/replay/create_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/delete_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/like_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/read_replays_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/update_replay_usecase.dart';

part 'replay_state.dart';

class ReplayCubit extends Cubit<ReplayState> {
  final CreateReplayUsecase createReplayUsecase;
  final ReadReplaysUsecase readReplaysUsecase;
  final UpdateReplayUsecase updateReplayUsecase;
  final DeleteReplayUsecase deleteReplayUsecase;
  final LikeReplayUsecase likeReplayUsecase;
  ReplayCubit(
   {required this.createReplayUsecase,
  required  this.readReplaysUsecase,
   required this.updateReplayUsecase,
   required this.deleteReplayUsecase,
   required this.likeReplayUsecase,}
  ) : super(ReplayInitial());


Future<void>createReplay({required ReplayEntity replay})async{
  try{
    await createReplayUsecase.call(replay);
  }on SocketException catch(_){
    emit(ReplayFailure());
  } catch(e){
emit(ReplayFailure());
  }
}



   Future<void> getReplays({required ReplayEntity replay}) async {
    emit(ReplayLoading());
    try {
      // ignore: non_constant_identifier_names
      final StreamResponse = readReplaysUsecase.call(replay);
      StreamResponse.listen((replay) {
        emit(ReplayLoaded(replays: replay));
      });
    } on SocketException catch (_) {
      emit(ReplayFailure());
    } catch (_) {
      emit(ReplayFailure());
    }
  }

  Future<void>likeReplay({required ReplayEntity replay})async{
  try{
    await likeReplayUsecase.call(replay);
  }on SocketException catch(_){
    emit(ReplayFailure());
  } catch(e){
    if (kDebugMode) {
      print(e);
    }
emit(ReplayFailure());
  }
}

Future<void>deleteReplay({required ReplayEntity replay})async{
  try{
    await deleteReplayUsecase.call(replay);
  }on SocketException catch(_){
    emit(ReplayFailure());
  } catch(e){
emit(ReplayFailure());
  }
}

Future<void>updateReplay({required ReplayEntity replay})async{
  try{
    await updateReplayUsecase.call(replay);
  }on SocketException catch(_){
    emit(ReplayFailure());
  } catch(e){
emit(ReplayFailure());
  }
}


}
