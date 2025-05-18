import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/log_in_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final LogInUserUsecase logInUserUsecase;
  final SignUpUserUsecase signUpUserUsecase;
  CredentialCubit({required this.logInUserUsecase,required this.signUpUserUsecase,}) : super(CredentialInitial());


Future<void>sigInUser({required String email,required String password})async{
  emit(CredentialLoading());
  try{
    
    await logInUserUsecase.call(UserEntity(email: email,password: password));
    print('its successs');
    emit(CredentialSuccess());

  }on SocketException catch(_){
    emit(CredentialFailure());
  } catch(e){
emit(CredentialFailure());
  }
}


// Future<void>signUpUser({required UserEntity user})async{
//   emit(CredentialLoading());
//   try{
//     await signUpUserUsecase.call(user);
//     emit(CredentialSuccess());
//   }on SocketException catch(_){
//     emit(CredentialFailure());
//   } catch(e){
// emit(CredentialFailure());
//   }
// }

Future<void> signUpUser({required UserEntity user}) async {
  emit(CredentialLoading());
  try {
    print("=== DEBUG: Signing up user with email: ${user.email} ===");
    await signUpUserUsecase.call(user);
    emit(CredentialSuccess());
    print("=== DEBUG: Sign-up successful! ===");
  } on SocketException catch (_) {
    print("=== DEBUG: No internet connection ===");
    emit(CredentialFailure());
  } catch (e, stackTrace) {
    print("=== DEBUG: Sign-up failed ===");
    print("Error: ${e.toString()}");
    print("StackTrace: $stackTrace");
    emit(CredentialFailure()); // Pass error message
  }
}


}
