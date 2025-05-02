import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:stream24news/models/live_channel_model.dart';
// import 'package:stream24news/pip/floating_video_manager.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/theme/my_tab_icons_icons.dart';
import 'floating_video_manager.dart';

class VideoPlayScreen extends StatefulWidget {
  final LiveChannelModel channel;
  const VideoPlayScreen({super.key, required this.channel});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool isReported = false;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.channel.url));
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    await _videoController.initialize();
    _chewieController =
        ChewieController(videoPlayerController: _videoController);
    setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final rootContext = Navigator.of(context).context; // root overlay context
    // Show PiP AFTER popping
    Navigator.of(context).pop(); // pop current screen
    // Wait for pop animation to complete
    await Future.delayed(const Duration(milliseconds: 100));

    FloatingVideoManager().show(rootContext, widget.channel.url);
    FloatingVideoManager().getModel(widget.channel);
    return false; // prevent default pop (already done manually)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(title: Text(widget.channel.name)),
          body: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController!,
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
              ),
              sizedBoxH10(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.channel.logo,
                      width: 50,
                      height: 50,
                    ),
                    sizedBoxW10(context),
                    Text(widget.channel.name),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() => isSelected = !isSelected);
                      },
                      icon: Icon(
                        isSelected
                            ? MyTabIcons.bookmark_fill
                            : MyTabIcons.bookmark,
                        size: 20,
                      ),
                      label: const Text('Save'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        // setState(() => isReported = !isReported);
                      },
                      icon: Icon(
                        Icons.flag_outlined,
                        size: 24,
                      ),
                      label: const Text('Report'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}








/*
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pip_view/pip_view.dart';
import 'package:stream24news/models/live_channel_model.dart';
import 'package:stream24news/utils/componants/bottom_navbar.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';
import 'package:stream24news/utils/theme/my_tab_icons_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayScreen extends StatefulWidget {
  final LiveChannelModel channel;
  const VideoPlayScreen({super.key, required this.channel});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late final VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  late Future<void> _initializeVideoFuture;
  bool isPipButtonVidible = true;

  bool isReported = false;
  bool isSelected = false;
  // 'https://ndtvindiaelemarchana.akamaized.net/hls/live/2003679/ndtvindia/master.m3u8',
  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.channel.url),
    );
    _initializeVideoFuture = _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: false,
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
          return floatingWidget();
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
                body: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FutureBuilder(
                        future: _initializeVideoFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return _chewieController != null
                                ? Chewie(controller: _chewieController!)
                                : const Center(child: Text("Player failed"));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    sizedBoxH10(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.channel.logo,
                            width: 50,
                            height: 50,
                          ),
                          sizedBoxW10(context),
                          Text(widget.channel.name),
                          Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              setState(() => isSelected = !isSelected);
                            },
                            icon: Icon(
                              isSelected
                                  ? MyTabIcons.bookmark_fill
                                  : MyTabIcons.bookmark,
                              size: 20,
                            ),
                            label: const Text('Save'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() => isReported = !isReported);
                            },
                            icon: Icon(
                              isReported ? Icons.flag_outlined : Icons.flag,
                              size: 24,
                            ),
                            label: const Text('Report'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget floatingWidget() {
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
            onTap: () => PIPView.of(context)?.stopFloating(),
            onTapCancel: () => PIPView.of(context)?.stopFloating(),
            child: const CircleAvatar(
              backgroundColor: Colors.black54,
              radius: 20,
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
*/