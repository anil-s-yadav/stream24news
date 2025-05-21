import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:stream24news/models/live_channel_model.dart';

import '../../utils/componants/sizedbox.dart';
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
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.channel.url));
    _initializePlayer();
    increaseView(widget.channel.channelDocId);
  }

  Future<void> _initializePlayer() async {
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
    );
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
      context.read<LiveTvBloc>().add(LiveTvDataLoadEvent());
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
                                // isSelected = !isSelected;
                                context.read<LiveTvBloc>().add(
                                    LiveChannelSaveEvent(
                                        channelID:
                                            widget.channel.channelDocId));
                              });
                            },
                            icon: Icon(
                              isSelected
                                  ? MyTabIcons.bookmarkFill
                                  : MyTabIcons.bookmark,
                              size: 20,
                            ),
                            label: const Text('Save'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("What's wrong?"),
                                        content: TextFormField(),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Cancel")),
                                          TextButton(
                                              onPressed: () {
                                                EasyLoading.showSuccess(
                                                    "Channel reported!");
                                                Navigator.pop(context);
                                              },
                                              child: Text("Report"))
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.flag_outlined,
                              size: 24,
                            ),
                            label: const Text('Report'),
                          )
                        ],
                      ),
                      Divider(),
                      sizedBoxH10(context),
                      BlocBuilder<LiveTvBloc, LiveTvState>(
                        buildWhen: (previous, current) =>
                            current is LoadRelatedChannelLoading ||
                            current is LoadRelatedChannelSuccess ||
                            current is LoadRelatedChannelError ||
                            current is LiveTvInitialState,
                        builder: (context, state) {
                          if (state is LoadRelatedChannelLoading ||
                              state is LiveTvInitialState) {
                            return channelsLoading();
                          } else if (state is LoadRelatedChannelSuccess) {
                            return relatedChannelsWidget(
                                state.liveChannelModel);
                          } else {
                            return channelsLoading();
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

  void increaseView(String docId) {
    Timer(const Duration(seconds: 5), () async {
      final docRef = FirebaseFirestore.instance
          .collection('live_chennels') // Corrected spelling
          .doc("6Kc57CnXtYzg85cD0FXS")
          .collection("all_channels")
          .doc(docId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        final data = snapshot.data();
        final Timestamp? lastViewed = data?['viewAt'];
        final DateTime now = DateTime.now();

        if (lastViewed == null ||
            now.difference(lastViewed.toDate()).inMinutes >= 5) {
          final currentViews = data?['viewCount'] ?? 0;
          transaction.update(docRef, {
            'viewCount': currentViews + 1,
            'viewAt': FieldValue.serverTimestamp(),
          });
        }
      });
    });
  }
}
