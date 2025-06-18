import 'package:flutter/material.dart';

class AboutusPage extends StatelessWidget {
  const AboutusPage({super.key});

  final String photo =
      "https://raw.githubusercontent.com/anil-s-yadav/stream24news_crm/refs/heads/main/lib/assets/news_app_logos/aboutus_logo.png";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("About us"),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/images/logo.jpeg",
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Stream24 News",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Version: 1.0.4 (5)",
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color
                              ?.withAlpha(153)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () => Navigator.pop(context), child: Text("Back"))
          ],
        ),
      ),
    );
  }
}
