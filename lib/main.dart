import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lumeo/features/presentation/cubit/auth/cubit/auth_cubit.dart';
import 'package:lumeo/features/presentation/cubit/bookmark/bookmark_cubit.dart';
import 'package:lumeo/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:lumeo/features/presentation/cubit/credential/cubit/credential_cubit.dart';
import 'package:lumeo/features/presentation/cubit/current_uid/current_uid_cubit.dart';
import 'package:lumeo/features/presentation/cubit/get_single_post/cubit/get_single_post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/post/cubit/post_cubit.dart';
import 'package:lumeo/features/presentation/cubit/replay_cubit/replay_cubit.dart';
import 'package:lumeo/features/presentation/cubit/savedposts/savedpost_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/get_single_user/cubit/get_single_user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/cubit/user/get_single_other_user/cubit/get_single_other_user_cubit.dart';
import 'package:lumeo/features/presentation/page/credentials/login_page.dart';
import 'package:lumeo/features/presentation/page/credentials/main_screen/main_screen.dart';
import 'package:lumeo/injection_container.dart' as di;
import 'package:lumeo/on_generate_route.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
      await dotenv.load(fileName: ".env");
  print("APP_ID: ${dotenv.env['APP_ID']}");
  print("APP_SIGN: ${dotenv.env['APP_SIGN']}");
  await di.init();
await ZIMKit().init(
  appID: int.parse('1351442505'),
  appSign:'0728e3ec78c7f8a881e30f44b997bc403f904fd6e2ee975f3ed799ef1bdbb26d', 
        
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..appStarted(context)),
        BlocProvider(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider(create: (_) => di.sl<UserCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleUserCubit>()),
        BlocProvider(create: (_) => di.sl<PostCubit>()),
        BlocProvider(create: (_) => di.sl<CommentCubit>()),
        BlocProvider(create: (_) => di.sl<GetSinglePostCubit>()),
        BlocProvider(create: (_) => di.sl<ReplayCubit>()),
        BlocProvider(create: (_) => di.sl<CurrentUidCubit>()),
        BlocProvider(create: (_) => di.sl<SavedpostCubit>()),
        BlocProvider(create: (_) => di.sl<BookmarkCubit>()),
        BlocProvider(create: (_) => di.sl<GetSingleOtherUserCubit>()),
      ],
      child: MaterialApp(
        title: 'Lumeo',
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: OnGenerateRoute.route,

        initialRoute: "/",
        routes: {
          "/": (context) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authstate) {
                print(authstate);
                if (authstate is Authenticated) {
                  return MainScreen(uid: authstate.uid);
                } else {
                  return LoginPage();
                }
              },
            );
          },
        },
      ),
    );
  }
}
