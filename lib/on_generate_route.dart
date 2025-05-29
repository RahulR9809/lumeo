import 'package:flutter/material.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/app_entities/app_entites.dart';
import 'package:lumeo/features/domain/entities/comment/comment_entity.dart';
import 'package:lumeo/features/domain/entities/post/post_entity.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/presentation/page/chat/chatpage.dart';
import 'package:lumeo/features/presentation/page/chat/userlistpage.dart';
import 'package:lumeo/features/presentation/page/credentials/login_page.dart';
import 'package:lumeo/features/presentation/page/credentials/register_page.dart';
import 'package:lumeo/features/presentation/page/post/comment/comment_page.dart';
import 'package:lumeo/features/presentation/page/post/comment/widget/edit_comment_page.dart';
import 'package:lumeo/features/presentation/page/post/post_detail_page/post_detail_page.dart';
import 'package:lumeo/features/presentation/page/post/update_post/update_post.dart';
import 'package:lumeo/features/presentation/page/profile/edit_profile_page.dart';
import 'package:lumeo/features/presentation/page/profile/followers_page.dart';
import 'package:lumeo/features/presentation/page/profile/following_page.dart';
import 'package:lumeo/features/presentation/page/profile/single_profilepage.dart';
import 'package:lumeo/features/presentation/page/savedpost/savedpost.dart';

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
          if (args is AppEntites) {
            return routebuilder(CommentPage(appEntites: args));
          }
          return routebuilder(NoPageFound());
        }
      case PageConst.updateCommentPage:
        {
          if (args is CommentEntity) {
            return routebuilder(UpdateCommentPage(comment: args));
          }
          return routebuilder(NoPageFound());
        }
      case PageConst.postDetailPage:
        {
          if (args is String) {
            return routebuilder(PostDetailPage(postId: args));
          }
          return routebuilder(NoPageFound());
        }
      case PageConst.singleProfilePage:
        {
          if (args is String) {
            return routebuilder(SingleProfilePage(otheruserId: args));
          }
          return routebuilder(NoPageFound());
        }
      case PageConst.savedPostpage:
        {
          return routebuilder(SavedPostpage());
        }


             case PageConst.followingPage:
        
          if (args is UserEntity) {
            return routebuilder(FollowingPage(user: args));
          }

               case PageConst.followersPage:
        
          if (args is UserEntity) {
            return routebuilder(FollowersPage(user: args));
          }
     case PageConst.chatPage:
        {
          if (args is Map<dynamic, dynamic>) {
            return routebuilder(ChatPage(
              currentUserId: args['currentUserId']!,
              peerId: args['peerId']!,
              peerName: args['peerName'],
              currentUserName: args["currentUserName"],
            ));
          }
        }
      case PageConst.userListPage:
        {
          return routebuilder(const Userlistpage());
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
