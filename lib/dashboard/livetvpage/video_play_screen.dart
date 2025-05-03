import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:stream24news/models/live_channel_model.dart';
// import 'package:stream24news/pip/floating_video_manager.dart';

import '../../utils/componants/sizedbox.dart';
import '../../utils/services/my_methods.dart';
import '../../utils/services/shared_pref_service.dart';
import '../../utils/theme/my_tab_icons_icons.dart';
import 'bloc/live_tv_bloc.dart';
import 'floating_video_manager.dart';

class VideoPlayScreen extends StatefulWidget {
  final LiveChannelModel channel;
  final String comingFrom;
  const VideoPlayScreen(
      {super.key, required this.channel, required this.comingFrom});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  // LiveTvBloc? _liveTvBloc;
  bool isReported = false;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.channel.url));
    _initializePlayer();
    // loadBloc();
  }

  // void loadBloc() {
  //   context
  //       .read<LiveTvBloc>()
  //       .add(LiveTvDataLoadEvent(resion: widget.channel.region));
  // }

  Future<void> _initializePlayer() async {
    await _videoController.initialize();
    _chewieController =
        ChewieController(videoPlayerController: _videoController);
    setState(() {});
    if (mounted) {
      context.read<LiveTvBloc>().add(
            LoadRelatedChannelEvent(language: widget.channel.language),
          );
    }
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
    if (widget.comingFrom == "LiveTvPage" && mounted) {
      final region = SharedPrefService().getCounty()![2];
      context.read<LiveTvBloc>().add(LiveTvDataLoadEvent(resion: region));
    }
    return false; // prevent default pop (already done manually)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          // appBar: AppBar(title: Text(widget.channel.name)),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  // aspectRatio: 16 / 9,
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black,
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
                  child: Column(
                    children: [
                      Row(
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
                              setState(() {
                                isSelected = !isSelected;
                                context.read<LiveTvBloc>().add(
                                    LiveChannelSaveEvent(
                                        channelID:
                                            widget.channel.channelDocId));
                              });
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
                      sizedBoxH20(context),
                      BlocBuilder<LiveTvBloc, LiveTvState>(
                        // bloc: _liveTvBloc,
                        buildWhen: (previous, current) =>
                            current is LoadRelatedChannelLoading ||
                            current is LoadRelatedChannelSuccess ||
                            current is LoadRelatedChannelError ||
                            current is LiveTvInitialState,
                        builder: (context, state) {
                          if (state is LoadRelatedChannelSuccess) {
                            return relatedChannelsWidget(
                                state.liveChannelModel);
                            // return channelsLoading();
                          } else if (state is LoadRelatedChannelLoading) {
                            return channelsLoading();
                          } else {
                            return noDataWidget(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget channelsLoading() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      children: List.generate(
        9,
        (index) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget relatedChannelsWidget(List<LiveChannelModel> channels) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      children: channels.map((channel) {
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => VideoPlayScreen(
                  channel: channel,
                  comingFrom: "",
                ),
              ),
            );
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: channel.logo,
                  height: 50,
                  width: 50,
                ),
                Text(channel.name, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      }).toList(),
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