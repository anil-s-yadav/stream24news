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
  double _width = 50;
  double _height = 40;
  bool _showLink = false;

  @override
  void initState() {
    super.initState();

    // Phase 1: Expand
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _width = 250;
        _height = 40;
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
        _width = 140;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: theme.colorScheme.shadow,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: CachedNetworkImageProvider(widget.logoUrl),
          ),
          if (_showLink) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.link,
                style: TextStyle(
                  fontSize: 13,
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
