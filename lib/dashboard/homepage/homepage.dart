import 'package:flutter/material.dart';
import 'package:stream24news/assets/componants/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("data"),
      ),
      body: Center(
        child: Column(children: [
          Text(
            "primarycolor",
            style: TextStyle(color: primaryColor),
          ),
          Text(
            "mateblack",
            style: TextStyle(color: mateBlack),
          ),
          Text(
            "coldgyar",
            style: TextStyle(color: coldGray),
          ),
          Container(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("data"),
            ),
          ),
        ]),
      ),
    );
  }
}
