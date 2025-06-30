import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:lumeo/features/data/data_sources/cloudinary/cloudinary_data_source_impl.dart';
import 'package:lumeo/features/data/data_sources/cloudinary/cludinary_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:lumeo/features/data/data_sources/remote_data_source/remote_data_source_impl.dart';
import 'package:lumeo/features/data/repository/firebase_repository_impl.dart';
import 'package:lumeo/features/domain/repository/firebase_repository.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/create_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/delete_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/like_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/read_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/comment/update_comment_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/create_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/delete_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/delete_saved_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/like_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/read_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/read_single_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/save_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/posts/update_post_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/storage/upload_post_image_to_storage.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/storage/upload_video_to_storage.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/create_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/follow_unfollow_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_other_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_single_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/google_signin_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/is_logged_in_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/log_in_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/singn_out_usecase.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/create_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/delete_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/like_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/read_replays_usecase.dart';
import 'package:lumeo/features/domain/usecases/replay/update_replay_usecase.dart';
import 'package:lumeo/features/domain/usecases/savedposts/read_savedpost_usecase.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:lumeo/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:lumeo/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:lumeo/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/replay_cubit/replay_cubit.dart';
import 'package:lumeo/features/presentation/cubit/savedposts/savedpost_cubit.dart';
import 'package:lumeo/features/presentation/cubit/theme/cubit/theme_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/get_single_other_user/cubit/get_single_other_user_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //cubits

  sl.registerFactory(
    () => AuthCubit(
      singnOutUsecase: sl.call(),
      isLoggedInUsecase: sl.call(),
      getCurrentUidUsecase: sl.call(), googleSignInUsecase: sl.call(),
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
      followUnfollowUsecase: sl.call(),
    ),
  );

  sl.registerFactory(() => GetSingleUserCubit(getSingleUserUsecase: sl.call()));
  sl.registerFactory(
    () => GetSingleOtherUserCubit(getSingleOtherUsecase: sl.call()),
  );

  sl.registerLazySingleton(
      () => GoogleSignInUsecase(firebaseRepository: sl.call()));

  //post cubit injection
  sl.registerFactory(
    () => PostCubit(
      createPostUsecase: sl.call(),
      deletePostUsecase: sl.call(),
      likePostUsecase: sl.call(),
      readPostUsecase: sl.call(),
      updatePostUsecase: sl.call(),
      savePostUsecase: sl.call(),
      deleteSavedPostUsecase: sl.call(),
    ),
  );

  sl.registerFactory(() => BookmarkCubit(readSavedpostUsecase: sl.call()));
  sl.registerFactory(
    () => SavedpostCubit(
      readSavedpostUsecase: sl.call(),
      readPostUsecase: sl.call(),
    ),
  );



  //comment cubit injection
  sl.registerFactory(
    () => CommentCubit(
      createCommentUsecase: sl.call(),
      deleteCommentUsecase: sl.call(),
      likeCommentUsecase: sl.call(),
      readCommentUsecase: sl.call(),
      updateCommentUsecase: sl.call(),
    ),
  );

  //singe post cubit injection
  sl.registerFactory(
    () => GetSinglePostCubit(readSinglePostUsecase: sl.call()),
  );

  //replay cubit injection
  sl.registerFactory(
    () => ReplayCubit(
      createReplayUsecase: sl.call(),
      deleteReplayUsecase: sl.call(),
      likeReplayUsecase: sl.call(),
      readReplaysUsecase: sl.call(),
      updateReplayUsecase: sl.call(),
    ),
  );

  //Use cases

  sl.registerLazySingleton(() => SingnOutUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => IsLoggedInUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetCurrentUuidUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SignUpUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LogInUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetUsersUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => CreateUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleUserUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => FollowUnfollowUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => GetSingleOtherUsecase(repository: sl.call()));


sl.registerFactory<ThemeCubit>(() => ThemeCubit());


  //cloudinary
  sl.registerLazySingleton(
    () => UploadProfileImageToStorageUseCase(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UploadPostImageToStorage(repository: sl.call()),
  );
  sl.registerLazySingleton(
    () => UploadVideoToStorageUseCase(repository: sl.call()),
  );

  //post
  sl.registerLazySingleton(() => CreatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadPostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdatePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeletePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSinglePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => SavePostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadSavedpostUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteSavedPostUsecase(repository: sl.call()));

  //Comment
  sl.registerLazySingleton(() => CreateCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateCommentUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteCommentUsecase(repository: sl.call()));

  //replay
  sl.registerLazySingleton(() => CreateReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => ReadReplaysUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => LikeReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => UpdateReplayUsecase(repository: sl.call()));
  sl.registerLazySingleton(() => DeleteReplayUsecase(repository: sl.call()));

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
  sl.registerFactory(() => CurrentUidCubit());
}
