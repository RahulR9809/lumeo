import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/page/credentials/login_page.dart';
import 'package:lumeo/features/presentation/page/credentials/register_page.dart';
import 'package:lumeo/features/presentation/page/post/commnet/comment_page.dart';
import 'package:lumeo/features/presentation/page/post/update_post/update_post.dart';
import 'package:lumeo/features/presentation/page/profile/edit_profile_page.dart';

class OnGenerateRoute {
  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case PageConst.editProfilepage:
        {
          if (args is UserEntity) {
            return routebuilder(EditProfilePage(currentUser: args));
          } else {
            return routebuilder(NoPageFound());
          }
        }
      case PageConst.updatePost:
        {
          if (args is PostEntity) {
            return routebuilder(UpdatePost(post: args));
          } else {
            return routebuilder(NoPageFound());
          }
        }
      case PageConst.loginPage:
        {
          return routebuilder(LoginPage());
        }
      case PageConst.signUpPage:
        {
          return routebuilder(SignUpPage());
        }
      case PageConst.commentPage:
        {
          return routebuilder(CommentPage());
        }
      default:
        {
          NoPageFound();
        }
    }
    return null;
  }
}

dynamic routebuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class NoPageFound extends StatelessWidget {
  const NoPageFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Page not found")));
  }
}
