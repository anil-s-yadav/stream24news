import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimatedLogoLinkBox extends StatefulWidget {
  final String link;
  final String logoUrl;
  const AnimatedLogoLinkBox(
      {super.key, required this.link, required this.logoUrl});

  @override
  State<AnimatedLogoLinkBox> createState() => _AnimatedLogoLinkBoxState();
}

class _AnimatedLogoLinkBoxState extends State<AnimatedLogoLinkBox> {
  double _width = 40;
  double _height = 30;
  bool _showLink = false;

  @override
  void initState() {
    super.initState();

    // Phase 1: Expand
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _width = 180;
        _height = 30;
      });
    });

    // Phase 2: Show link
    Future.delayed(const Duration(milliseconds: 1100), () {
      setState(() {
        _showLink = true;
      });
    });

    // Phase 3: Final compact size
    Future.delayed(const Duration(milliseconds: 2500), () {
      setState(() {
        _width = 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      margin: EdgeInsets.all(5),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: theme.colorScheme.shadow,
        borderRadius: BorderRadius.circular(20),
      ),
      // margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 11,
            backgroundImage: CachedNetworkImageProvider(widget.logoUrl),
          ),
          if (_showLink) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.link,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.surface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
