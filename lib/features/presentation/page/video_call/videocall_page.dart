import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';


class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final String userID = 'user_${DateTime.now().millisecondsSinceEpoch}';
  final String callID = 'test_channel';

  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    final cameraGranted = statuses[Permission.camera]!.isGranted;
    final micGranted = statuses[Permission.microphone]!.isGranted;

    if (cameraGranted && micGranted) {
      setState(() {
        _permissionsGranted = true;
      });
    } else {
      // Optionally, show a dialog explaining why permissions are needed.
    }
  }

  @override
  Widget build(BuildContext context) {

    final config = ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
  ..turnOnCameraWhenJoining = true
  ..turnOnMicrophoneWhenJoining = true;

return SafeArea(
  child: _permissionsGranted
      ? ZegoUIKitPrebuiltCall(
          appID: 1351442505,
          appSign: '0728e3ec78c7f8a881e30f44b997bc403f904fd6e2ee975f3ed799ef1bdbb26d',
          userID: userID,
          userName: 'User_$userID',
          callID: callID,
          config: config,
        )
      : const Center(child: CircularProgressIndicator()),
);

  }
}
