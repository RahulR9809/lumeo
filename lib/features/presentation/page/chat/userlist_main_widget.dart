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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color:Theme.of(context).colorScheme.surface ,)),
        title: const Text("Chats"),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 1,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final currentUser = state.users.firstWhere(
              (user) => user.uid == uid,
            );
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
    return UserTileWidget(
      user: user,
      currentUserId: uid,
      currentUserName: currentUser.username,
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
class UserTileWidget extends StatelessWidget {
  final UserEntity user;
  final String? currentUserId;
  final String? currentUserName;

  const UserTileWidget({
    super.key,
    required this.user,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16), // 👈 Border radius
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: SizedBox(
            width: 40,
            height: 40,
            child: profilewidget(imageUrl: user.profileUrl),
          ),
          title: Text(
            user.username ?? 'No Name',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          subtitle: Text(
            user.email ?? '',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.surface,
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              PageConst.chatPage,
              arguments: {
                'currentUserId': currentUserId,
                'peerId': user.uid,
                'peerName': user.username,
                'currentUserName': currentUserName,
              },
            );
          },
        ),
      ),
    );
  }
}
