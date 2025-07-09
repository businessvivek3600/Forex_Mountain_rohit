import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Updated import

class YoutubePlayerPageNew extends StatefulWidget {
  const YoutubePlayerPageNew({Key? key}) : super(key: key);

  static const String routeName = '/ytLiveNew';

  @override
  _YoutubePlayerPageNewState createState() => _YoutubePlayerPageNewState();
}

class _YoutubePlayerPageNewState extends State<YoutubePlayerPageNew> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Stack(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                _controller.addListener(() {
                });
              },
            ),
            // _buildLandscape(context),
          ],
        );
      },
    );
  }

  Widget _buildPortrait(BuildContext context, Widget player) {
    return player;
  }

  Widget _buildLandscape(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: LayoutBuilder(builder: (context, bound) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.redAccent.withOpacity(0.2),
              ),
              // build stack none
              _buildStackNone(),
              // build stack controls
              _buildControls(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStackNone() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black.withOpacity(0.0),
        child: Center(
          child: Text(
            'Hello',
            style: TextStyle(color: Colors.white, fontSize: 32),
          ),
        ),
      ),
    );
  }
}

class _buildControls extends StatelessWidget {
  const _buildControls();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProviderNew>(builder: (context, provider, _) {
      var controller = provider.controller;
      var state = controller.value.playerState;
      var isPlaying = state == PlayerState.playing;
      var isPaused = state == PlayerState.paused;
      var isBuffering = state == PlayerState.buffering;
      var duration = controller.metadata.duration;
      var position = provider.progressNotifier.value;

      return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: LayoutBuilder(builder: (context, bound) {
          return Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: [
                Container(
                  color: Colors.red.withOpacity(0.5),
                  height: bound.maxHeight * 0.2,
                  child: Row(
                    children: [],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              color: Colors.blue.withOpacity(0.5),
                              child: Center(
                                child: Icon(
                                  Icons.replay_10,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              color: Colors.blue.withOpacity(0.5),
                              child: Center(
                                child: Icon(
                                  Icons.forward_10,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.red.withOpacity(0.5),
                  height: bound.maxHeight * 0.1,
                  child: PlayPauseButtonBar(),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}

class PlayPauseButtonBar extends StatelessWidget {
  PlayPauseButtonBar({super.key});
  final ValueNotifier<bool> _isMuted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProviderNew>(builder: (context, provider, _) {
      var playerState = provider.value.playerState;
      var isFullScreen = false;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              playerState == PlayerState.playing
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
            onPressed: () {
              playerState == PlayerState.playing
                  ? provider.controller.pause()
                  : provider.controller.play();
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _isMuted,
            builder: (context, isMuted, _) {
              return IconButton(
                icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  _isMuted.value = !isMuted;
                  isMuted
                      ? provider.controller.setVolume(0)
                      : provider.controller.setVolume(1);
                },
              );
            },
          ),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          IconButton(
            icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
            onPressed: () {
              // Handle fullscreen toggle
            },
          ),
        ],
      );
    });
  }
}

class PlayerProviderNew extends ChangeNotifier {
  late YoutubePlayerController controller;
  ValueNotifier<double> _progressNotifier = ValueNotifier(0.0);

  ValueNotifier<double> get progressNotifier => _progressNotifier;

  late YoutubePlayerValue value;

  Future<void> init() async {}

// Additional methods if needed
}
