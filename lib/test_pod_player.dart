import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';

class PlayVideoFromYoutube extends StatefulWidget {
  const PlayVideoFromYoutube({super.key});

  @override
  State<PlayVideoFromYoutube> createState() => _PlayVideoFromYoutubeState();
}

class _PlayVideoFromYoutubeState extends State<PlayVideoFromYoutube> {
  late final PodPlayerController controller;
  bool isVideoPlayable = true;

  @override
  void initState() {
    super.initState();
    checkVideoAvailability();
  }

  Future<void> checkVideoAvailability() async {
    try {
      controller = PodPlayerController(
        playVideoFrom: PlayVideoFrom.youtube('https://www.youtube.com/watch?v=6tWvJ-BLhbs'),
      )..initialise();
    } catch (e) {
      setState(() {
        isVideoPlayable = false;
      });
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isVideoPlayable
          ? PodVideoPlayer(controller: controller)
          : Center(child: Text("This video cannot be played. Please sign in or check restrictions.")),
    );
  }
}
