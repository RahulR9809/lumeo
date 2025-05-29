import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/consts.dart';
import 'package:lumeo/features/domain/entities/user/user_entity.dart';
import 'package:lumeo/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:lumeo/features/presentation/cubit/user/cubit/user_cubit.dart';
import 'package:lumeo/features/presentation/widgets/widget_profile.dart';


class UsersListMainWidget extends StatefulWidget {
  final GetCurrentUuidUsecase getCurrentUuidUsecase;
  const UsersListMainWidget({required this.getCurrentUuidUsecase, super.key});

  @override
  State<UsersListMainWidget> createState() => _UsersListMainWidgetState();
}

class _UsersListMainWidgetState extends State<UsersListMainWidget> {
  String? uid;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    uid = await widget.getCurrentUuidUsecase.call();
    if (uid != null) {
      context.read<UserCubit>().getUsers(user: UserEntity(uid: uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        backgroundColor: backGroundColor,
        elevation: 1,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final currentUser = state.users.firstWhere((user) => user.uid == uid);
            final users = state.users.where((user) => user.uid != uid).toList();

            if (users.isEmpty) {
              return const Center(child: Text("No other users found."));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: users.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
leading: SizedBox(
  width: 40,  // or any fixed width you want for the avatar
  height: 40, // keep height consistent with width
  child: profilewidget(imageUrl: user.profileUrl),
),
                  title: Text(
                    user.username ?? 'No Name',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    user.email ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageConst.chatPage,
                      arguments: {
                        'currentUserId': uid,
                        'peerId': user.uid,
                        'peerName': user.username,
                        'currentUserName': currentUser.username,
                      },
                    );
                  },
                );
              },
            );
          } else if (state is UserFailure) {
            return const Center(child: Text("Failed to load users."));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
