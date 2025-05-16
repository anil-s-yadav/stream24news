import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate us"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 55),
                title: Text("anilyadav44x@okhdfcbank"),
                trailing: IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: "anilyadav44x@okhdfcbank"));
                      EasyLoading.showToast("Copied to clipboard");
                    },
                    icon: Icon(Icons.copy))),
            sizedBoxH30(context),
            Image.asset(
              "lib/assets/images/qrcode.jpeg",
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: '\nThis app is '),
                  TextSpan(
                    text: 'free',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' to use!'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Text(
                  textAlign: TextAlign.center,
                  "\nThis donation will be motivate developers for improvement and management of this app. \n We also have to maintain servers."),
            ),
          ],
        ),
      ),
    );
  }
}
