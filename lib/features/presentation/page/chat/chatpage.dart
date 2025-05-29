// import 'package:flutter/material.dart';
// import 'package:zego_zimkit/zego_zimkit.dart';

// class ChatPage extends StatefulWidget {
//   final String currentUserId;
//   final String currentUserName;
//   final String peerId;
//   final String peerName;

//   const ChatPage(
//       {super.key,
//       required this.currentUserId,
//       required this.peerId,
//       required this.peerName,
//       required this.currentUserName});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   late Future<void> _connectFuture;

//   @override
//   void initState() {
//     super.initState();

//     // _connectFuture = ZIMKit()
//     //     .connectUser(
//     //   id: widget.currentUserId,
//     //   name: widget.currentUserName,
//     // )
//     //     .then((_) {
//     //   return ZIMKit().updateUserInfo(name: widget.currentUserName);
//     // });

//      _connectFuture = _connectUser();

//   }

//   Future<void> _connectUser() async {
//   try {
//     debugPrint("Connecting user...");
//     await ZIMKit().connectUser(
//       id: widget.currentUserId,
//       name: widget.currentUserName,
//     );
//     debugPrint("User connected. Updating user info...");
//     await ZIMKit().updateUserInfo(name: widget.currentUserName);
//     debugPrint("User info updated.");
//   } catch (e, stack) {
//     debugPrint("Error connecting user: $e");
//     debugPrint("Stacktrace: $stack");
//     rethrow;
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.peerName),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => VideoCallPage()));
//               },
//               icon: const Icon(Icons.video_call))
//         ], 
//       ),
//       body: FutureBuilder(
//         future: _connectFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Failed to connect: ${snapshot.error}'));
//           }

//           return ZIMKitMessageListPage(
//             conversationID: widget.peerId,
//             conversationType: ZIMConversationType.peer,
//           );
//         },
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:lumeo/features/presentation/page/video_call/videocall_page.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatPage extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final String peerId;
  final String peerName;

  const ChatPage({
    super.key,
    required this.currentUserId,
    required this.peerId,
    required this.peerName,
    required this.currentUserName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<void> _connectFuture;

  @override
  void initState() {
    super.initState();
    debugPrint('[ChatPage] initState called');
    _connectFuture = _connectUser();
  }

  Future<void> _connectUser() async {
    try {
      debugPrint('[ChatPage] Attempting to connect user: id=${widget.currentUserId}, name=${widget.currentUserName}');
      await ZIMKit().connectUser(
      id: widget.currentUserId,
      name: widget.currentUserName,
    );
      debugPrint('[ChatPage] User connected successfully');

      debugPrint('[ChatPage] Updating user info with name: ${widget.currentUserName}');
      await ZIMKit().updateUserInfo(name: widget.currentUserName);
      debugPrint('[ChatPage] User info updated successfully');
    } catch (e, stack) {
      debugPrint('[ChatPage] Error connecting user: $e');
      debugPrint('[ChatPage] Stacktrace:\n$stack');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('[ChatPage] build called');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peerName),
        actions: [
          IconButton(
            onPressed: () {
              debugPrint('[ChatPage] Video call button pressed (functionality commented out)');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VideoCallPage()));
            },
            icon: const Icon(Icons.video_call),
          )
        ],
      ),
      body: FutureBuilder(
        future: _connectFuture,
        builder: (context, snapshot) {
          debugPrint('[ChatPage] FutureBuilder state: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('[ChatPage] Connection in progress, showing loading indicator');
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            debugPrint('[ChatPage] Connection failed with error: ${snapshot.error}');
            return Center(child: Text('Failed to connect: ${snapshot.error}'));
          } else {
            debugPrint('[ChatPage] Connection successful, showing message list');
            return ZIMKitMessageListPage(
              conversationID: widget.peerId,
              conversationType: ZIMConversationType.peer,
            );
          }
        },
      ),
    );
  }
}
