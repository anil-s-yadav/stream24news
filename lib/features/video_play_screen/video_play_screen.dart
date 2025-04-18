import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pip_view/pip_view.dart';
import 'package:stream24news/utils/componants/bottom_navbar.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayScreen extends StatefulWidget {
  const VideoPlayScreen({super.key});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late Future<void> _initializeVideoFuture;
  bool isPipButtonVidible = true;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://ndtvindiaelemarchana.akamaized.net/hls/live/2003679/ndtvindia/master.m3u8',
      ),
    );
    _initializeVideoFuture = _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          zoomAndPan: true);
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PIPView(
      floatingHeight: 135,
      floatingWidth: 240,
      initialCorner: PIPViewCorner.topRight,
      builder: (context, isFloating) {
        if (isFloating) {
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(controller: _chewieController!),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTapDown: (_) {
                    PIPView.of(context)?.stopFloating();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 20,
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        } else {
          return PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (!didPop) {
                log("Back pressed, going to PiPView");
                PIPView.of(context)!.presentBelow(BottomNavbar(index: 1));
              }
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.black,
                floatingActionButton: Visibility(
                  visible: isPipButtonVidible,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white54,
                    elevation: 20,
                    tooltip: 'Picture-in-Picture',
                    onPressed: () {
                      PIPView.of(context)!.presentBelow(BottomNavbar(index: 1));
                    },
                    child: const Icon(
                      Icons.picture_in_picture_alt,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                body: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: FutureBuilder(
                    future: _initializeVideoFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _chewieController != null
                            ? Chewie(controller: _chewieController!)
                            : const Center(child: Text("Player failed"));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
