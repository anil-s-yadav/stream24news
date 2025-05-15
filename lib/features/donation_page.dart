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
            Text("\nThis app is free to use!"),
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  "\nThis donation will be motivate developers for improvement and management of this app. \n We also have to maintain servers."),
            )
          ],
        ),
      ),
    );
  }
}
