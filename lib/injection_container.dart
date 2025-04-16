import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:lumeo/features/data/repository/firebase_repository_impl.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/is_logged_in_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/log_in_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/singn_out_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //cubits

  sl.registerFactory(
    () => AuthCubit(
      singnOutUsecase: sl.call(),
      isLoggedInUsecase: sl.call(),
      getCurrentUidUsecase: sl.call(),
    ),
  );



  sl.registerFactory(
    () => CredentialCubit(
      signUpUserUsecase: sl.call(),
      logInUserUsecase: sl.call(),
    ),
  );



  sl.registerFactory(
    () => UserCubit(
      updateUserUsecase: sl.call(),
      getUsersUsecase: sl.call(),
      
    ),
  );

  sl.registerFactory(()=>GetSingleUserCubit(getSingleUserUsecase: sl.call()));

  //Use cases


  sl.registerLazySingleton(() => SingnOutUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsLoggedInUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUidUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LogInUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUsecase(repository: sl.call()));

  
  //Repository

sl.registerLazySingleton<FirebaseRepository>(()=>FirebaseRepositoryImpl(remoteDataSource: sl.call()));



  //Remote data source

sl.registerLazySingleton<FirebaseRemoteDataSource>(()=>FirebaseRemoteDataSourceImpl(firebaseFirestore: sl.call(), firebaseAuth: sl.call()));




  //Externals


final firebaseFireStore=FirebaseFirestore.instance;
final firebaseAuth=FirebaseAuth.instance;


sl.registerLazySingleton(()=>firebaseFireStore);
sl.registerLazySingleton(()=>firebaseAuth);


}
