import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:stream24news/models/live_channel_model.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';
import 'video_play_screen.dart';

class FloatingVideoManager {
  static final FloatingVideoManager _instance =
      FloatingVideoManager._internal();
  factory FloatingVideoManager() => _instance;
  FloatingVideoManager._internal();

  OverlayEntry? _overlayEntry;
  ChewieController? chewieController;
  VideoPlayerController? videoController;
  LiveChannelModel? channel;
  void getModel(LiveChannelModel channelModel) {
    channel = channelModel;
  }

  void show(BuildContext context, String url) async {
    if (_overlayEntry != null) return;

    videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await videoController!.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoController!,
      aspectRatio: videoController!.value.aspectRatio,
      autoPlay: true,
      looping: true,
      showControls: false,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        right: 10,
        child: Draggable(
          feedback: _buildPlayer(),
          child: _buildPlayer(),
          childWhenDragging: const SizedBox(),
        ),
      ),
    );

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    overlay.insert(_overlayEntry!);
  }

  Widget _buildPlayer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () => maximize(),
          child: Container(
            width: 240,
            height: 135,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: chewieController != null
                      ? Chewie(controller: chewieController!)
                      : const Center(child: CircularProgressIndicator()),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: hide,
                    child: const CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 14,
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hide() {
    chewieController?.dispose();
    videoController?.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void maximize() {
    chewieController?.dispose();
    videoController?.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => VideoPlayScreen(channel: channel!)),
    );
  }
}
