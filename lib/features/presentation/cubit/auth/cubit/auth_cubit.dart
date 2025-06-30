import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/google_signin_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/is_logged_in_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/singn_out_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SingnOutUsecase singnOutUsecase;
  final IsLoggedInUsecase isLoggedInUsecase;
  final GetCurrentUuidUsecase getCurrentUidUsecase;
  final GoogleSignInUsecase googleSignInUsecase;
  AuthCubit({
        required this.googleSignInUsecase,
    required this.singnOutUsecase,
    required this.isLoggedInUsecase,
    required this.getCurrentUidUsecase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    if (kDebugMode) {
      print('this is hereeeeeeeeeeee ');
    }
    try {
      bool isLogin = await isLoggedInUsecase.call();
      if (kDebugMode) {
        print('this is hereeeeeeeeeeee $isLogin');
      }
      if (isLogin == true) {
        final uid = await getCurrentUidUsecase.call();
        emit(Authenticated(uid: uid));
        if (kDebugMode) {
          print('this is the uid $uid');
        }
      }
    } catch (error) {
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      if (kDebugMode) {
        print('its logged in');
      }
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


    Future<void> googleSignIn() async {
 
    try {
      final uid = await googleSignInUsecase.call();
      emit(Authenticated(uid: uid));
    } on SocketException catch (e) {
            if (kDebugMode) {
              print("teh error is $e");
            }

      emit(UnAuthenticated());
    } catch (e) {
      if (kDebugMode) {
        print("teh error is $e");
      }
      emit(UnAuthenticated());
    }
  }
}
