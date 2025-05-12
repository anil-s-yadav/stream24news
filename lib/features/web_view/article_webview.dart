import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleWebview extends StatefulWidget {
  final String link;
  const ArticleWebview({super.key, required this.link});

  @override
  State<ArticleWebview> createState() => _ArticleWebviewState();
}

class _ArticleWebviewState extends State<ArticleWebview> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Back to Stream24 News app",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
