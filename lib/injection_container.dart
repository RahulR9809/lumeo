import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:lumeo/features/data/data_sources/cloudinary/cloudinary_data_source_impl.dart';
import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:lumeo/features/data/repository/firebase_repository_impl.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/read_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/update_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/storage/upload_post_image_to_storage.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/storage/upload_video_to_storage.dart';
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
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/page/post/update_post/update_post.dart';

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
    () => UserCubit(updateUserUsecase: sl.call(), getUsersUsecase: sl.call()),
  );

  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUsecase: sl.call()));

  //post cubit injection
  sl.registerFactory(
    () => PostCubit(
      createPostUsecase: sl.call(),
      deletePostUsecase: sl.call(),
      likePostUsecase: sl.call(),
      readPostUsecase: sl.call(),
      updatePostUsecase: sl.call(),
    ),
  );

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
  sl.registerLazySingleton(
    () => UploadProfileImageToStorageUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UploadPostImageToStorage(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UploadVideoToStorageUseCase(repository: sl.call()),
  );

  //Cloud Storage
  // sl.registerLazySingleton(()=>UploadProfileImageToStorageUseCase(repository: sl.call()));
  //   sl.registerLazySingleton(()=>UploadPostImageToStorage(repository: sl.call()));
  // sl.registerLazySingleton(()=>UploadVideoToStorageUseCase(repository: sl.call()));


//post
  sl.registerLazySingleton(()=>CreatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(()=>ReadPostUsecase(repository: sl.call()));
  sl.registerLazySingleton(()=>LikePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(()=>UpdatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(()=>DeletePostUsecase(repository: sl.call()));


  //Repository

  sl.registerLazySingleton<FirebaseRepository>(
    () => FirebaseRepositoryImpl(
      cloudinaryRepository: sl.call(),
      firebaseRemoteDataSource: sl.call(),
    ),
  );

  //Remote data source

  sl.registerLazySingleton<FirebaseRemoteDataSource>(
    () => FirebaseRemoteDataSourceImpl(
      firebaseFirestore: sl.call(),
      firebaseAuth: sl.call(),
      cloudinaryRepository: sl.call(),
    ),
  );

  //data source

  sl.registerLazySingleton<CloudinaryRepository>(
    () => CloudinaryRepositoryImpl(
      firebaseAuth: sl.call(),
      firebaseFirestore: sl.call(),
    ),
  );

  //Externals

  final firebaseFireStore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  sl.registerLazySingleton(() => firebaseFireStore);
  sl.registerLazySingleton(() => firebaseAuth);
}
