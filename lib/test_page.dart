import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:android_pip/android_pip.dart';
/*
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
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _enterPipMode() async {
    final isAvailable = await AndroidPIP.isPipAvailable;
    if (isAvailable) {
      // _videoPlayerController.pause(); // Optional
      await AndroidPIP().enterPipMode(
        aspectRatio: [16, 9],
      );
      log("Pip executed on this device.");
      setState(() {
        isPipButtonVidible = false;
      });
    } else {
      log("❌ PiP not supported on this device.");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Picture-in-Picture is not supported on this device.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: Visibility(
          visible: isPipButtonVidible,
          child: FloatingActionButton(
            backgroundColor: Colors.white54,
            elevation: 20,
            tooltip: 'Picture-in-Picture',
            onPressed: _enterPipMode,
            child: const Icon(
              Icons.picture_in_picture_alt,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            children: [
              FutureBuilder(
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
              Positioned(
                top: 10,
                right: 40,
                child: const Icon(
                  Icons.picture_in_picture_alt,
                  size: 30,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
*/
