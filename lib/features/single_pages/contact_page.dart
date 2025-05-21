import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              "lib/assets/images/logo.jpeg",
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 24),
            Text(
              "We'd love to hear from you!",
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Reach out for feedback, questions, or support.",
              style:
                  theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: const Text("support@stream24news.com"),
              trailing: IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: "text"));
                    EasyLoading.showToast(
                        "'support@stream24news.com' \n Copied to clipboard");
                  },
                  icon: Icon(Icons.copy)),
            ),
            const Divider(),
            // ListTile(
            //   leading: const Icon(Icons.phone),
            //   title: const Text("Phone"),
            //   subtitle: const Text("+91 98765 43210"),
            // ),
            // const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Address"),
              subtitle: const Text("Mumbai, Maharashtra, India"),
            ),
            const Divider(height: 40),
            // Text(
            //   "Follow us on",
            //   style: theme.textTheme.titleMedium,
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       icon: const FaIcon(FontAwesomeIcons.facebook),
            //       onPressed: () {},
            //     ),
            //     IconButton(
            //       icon: const FaIcon(FontAwesomeIcons.twitter),
            //       onPressed: () {},
            //     ),
            //     IconButton(
            //       icon: const FaIcon(FontAwesomeIcons.instagram),
            //       onPressed: () {},
            //     ),
            //     IconButton(
            //       icon: const FaIcon(FontAwesomeIcons.linkedin),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
