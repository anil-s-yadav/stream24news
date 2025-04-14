import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:android_pip/android_pip.dart';

class VideoPlayScreen extends StatefulWidget {
  const VideoPlayScreen({super.key});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late Future<void> _initializeVideoFuture;

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
      await AndroidPIP().enterPipMode(
        aspectRatio: const Size(16, 9),
      );
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
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _enterPipMode(); // Enter PiP on back button
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white54,
          elevation: 20,
          tooltip: 'Increment',
          onPressed: _enterPipMode,
          child: const Icon(
            Icons.picture_in_picture_alt,
            size: 30,
            color: Colors.white,
          ),
        ),
        body: SizedBox(
          height: 400,
          child: FutureBuilder(
            future: _initializeVideoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Chewie(controller: _chewieController!);
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
