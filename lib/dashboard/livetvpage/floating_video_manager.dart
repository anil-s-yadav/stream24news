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
  Future<void>? _initFuture;
  int _sessionToken = 0;

  void getModel(LiveChannelModel channelModel) {
    channel = channelModel;
  }

  /// Shows the PiP overlay immediately by reusing an existing [controller]
  /// handed off from [VideoPlayScreen] so playback continues without reloading.
  Future<void> showWithController({
    required LiveChannelModel channelModel,
    required VideoPlayerController controller,
    Future<void>? initFuture,
  }) async {
    if (videoController == controller) {
      videoController = null;
    }
    hide();
    final token = ++_sessionToken;
    channel = channelModel;
    videoController = controller;
    _initFuture = initFuture;

    if (controller.value.isInitialized) {
      _attachChewie(controller);
    }

    _insertOverlay();

    if (!controller.value.isInitialized) {
      final activeInit = _initFuture ??= controller.initialize();
      try {
        await activeInit;
      } catch (_) {
        if (token == _sessionToken) {
          hide();
        }
        return;
      }
      if (token != _sessionToken || videoController != controller) {
        return;
      }
      _attachChewie(controller);
      _overlayEntry?.markNeedsBuild();
    }
  }

  void show(BuildContext context, String url) async {
    hide();
    final token = ++_sessionToken;
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    videoController = controller;

    _insertOverlay();

    final initFuture = controller.initialize();
    _initFuture = initFuture;
    try {
      await initFuture;
    } catch (_) {
      if (token == _sessionToken) {
        hide();
      } else {
        controller.dispose();
      }
      return;
    }

    if (token != _sessionToken || videoController != controller) {
      controller.dispose();
      return;
    }

    _attachChewie(controller);
    _overlayEntry?.markNeedsBuild();
  }

  void _attachChewie(VideoPlayerController controller) {
    final aspect = controller.value.aspectRatio;
    chewieController?.dispose();
    chewieController = ChewieController(
      videoPlayerController: controller,
      aspectRatio: aspect > 0 ? aspect : 16 / 9,
      autoPlay: true,
      looping: true,
      showControls: false,
    );
    if (!controller.value.isPlaying) {
      controller.play();
    }
  }

  void _insertOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        right: 10,
        child: Draggable(
          feedback: _buildPlayer(),
          childWhenDragging: const SizedBox(),
          child: _buildPlayer(),
        ),
      ),
    );

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) {
      _overlayEntry = null;
      return;
    }

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
    _sessionToken++;
    _initFuture = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    chewieController?.dispose();
    chewieController = null;
    final vc = videoController;
    videoController = null;
    vc?.pause();
    vc?.dispose();
  }

  void maximize() {
    final targetChannel = channel;
    final context = navigatorKey.currentContext;
    if (targetChannel == null || context == null) {
      hide();
      return;
    }

    _sessionToken++;
    final transferredController = videoController;
    final transferredInitFuture = _initFuture;
    videoController = null;
    _initFuture = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
    chewieController?.dispose();
    chewieController = null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayScreen(
          channel: targetChannel,
          comingFrom: "",
          existingController: transferredController,
          existingInitFuture: transferredInitFuture,
        ),
      ),
    );
  }
}
