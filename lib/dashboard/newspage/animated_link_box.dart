import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimatedLogoLinkBox extends StatefulWidget {
  final String link;
  final String logoUrl;

  const AnimatedLogoLinkBox({
    super.key,
    required this.link,
    required this.logoUrl,
  });

  @override
  State<AnimatedLogoLinkBox> createState() => _AnimatedLogoLinkBoxState();
}

class _AnimatedLogoLinkBoxState extends State<AnimatedLogoLinkBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _widthAnim;
  bool _showLink = false;
  bool _showBox = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _widthAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 40.0, end: 180.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 180.0, end: 100.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Delay for 10 seconds to avoid performance issues during scroll
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        _showBox = true;
      });
      _controller.forward();
    });

    // Show link midway
    Future.delayed(const Duration(seconds: 8, milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _showLink = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_showBox) return const SizedBox(); // Don't render until ready

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _widthAnim,
        builder: (context, child) {
          return Container(
            width: _widthAnim.value,
            height: 30,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.shadow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: widget.logoUrl,
                    width: 22,
                    height: 22,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 1),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 18),
                  ),
                ),
                if (_showLink) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Uri.tryParse(widget.link)?.host ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
