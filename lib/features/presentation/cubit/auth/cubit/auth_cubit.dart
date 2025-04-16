import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/is_logged_in_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/singn_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SingnOutUsecase singnOutUsecase;
  final IsLoggedInUsecase isLoggedInUsecase;
  final GetCurrentUidUsecase getCurrentUidUsecase;
  AuthCubit({
    required this.singnOutUsecase,
    required this.isLoggedInUsecase,
    required this.getCurrentUidUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isLogin = await isLoggedInUsecase.call();
      if (isLogin == true) {
        final uid = await getCurrentUidUsecase.call();
        emit(Authenticated(uid: uid));
        print('this is the uid $uid');
      }
    } catch (error) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = await getCurrentUidUsecase.call();
      emit(Authenticated(uid: uid));
    } catch (error) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    try {
      await singnOutUsecase.call();
      emit(UnAuthenticated());
    } catch (error) {
      emit(UnAuthenticated());
    }
  }
}
