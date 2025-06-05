import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  final List<Map<String, String>> supporters = const [
    {
      'name': 'Ravi Varma',
      'icon': "8",
      'rupees': '₹50',
      'message': 'This app help me a lot, keep working bro!',
    },
    {
      'name': 'Bipin Gupta',
      'icon': "6",
      'rupees': '₹120',
      'message': 'I always here to support you brother!!',
    },
    {
      'name': 'Vinay',
      'icon': "1",
      'rupees': '₹20',
      'message': 'I found these live channels very helpful.',
    },
    {
      'name': 'Surendra Yadav',
      'icon': "5",
      'rupees': '₹300',
      'message': 'Now I am always updated.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Developers!"),
        backgroundColor: theme.colorScheme.surfaceContainerLow,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // UPI Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectableText(
                          "anilyadav44x@okhdfcbank",
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(
                                text: "anilyadav44x@okhdfcbank"));
                            EasyLoading.showToast("Copied to clipboard");
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "lib/assets/images/qrcode.jpeg",
                        height: 240,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Scan to pay with any UPI app",
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info Text
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: const [
                  TextSpan(text: 'This app is '),
                  TextSpan(
                    text: 'free',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' to use!'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Your donation helps keep this app maintained and improved. We also need it for server costs.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),

            const Divider(height: 30, thickness: 1),
            Text(
              "Supporters ❤️\n",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...supporters.map((supporter) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                            'https://api.dicebear.com/7.x/adventurer/png?seed=${supporter['icon']}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${supporter['name']} ",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "donated ${supporter['rupees']}.",
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.tertiaryFixed,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                supporter['message']!,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).colorScheme.scrim),
                              ),
                            ),
                            sizedBoxH10(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
