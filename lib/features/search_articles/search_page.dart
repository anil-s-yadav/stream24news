import 'package:flutter/material.dart';
import 'package:stream24news/utils/componants/sizedbox.dart';

import '../../auth/create_account/list_data/language_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [],
      ),
    );
  }

  Widget filter(String hint) {
    return Container(
      height: 37,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.onPrimaryContainer,
        // ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // value: selectedLanguage,
          hint: Text(
            hint,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary, fontSize: 13),
          ),
          iconEnabledColor: Theme.of(context).colorScheme.primary,
          items: languages.keys.map((key) {
            return DropdownMenuItem(
              value: key,
              child: Text(
                key,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              // onLanguageSelected(newValue);
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      toolbarHeight: MediaQuery.of(context).size.height * 0.120,
      title: Column(
        children: [
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: Colors.black26,
            child: TextField(
              // autofocus: true,
              // onSubmitted: (value) => callAllLeads(value),
              // onChanged: (value) => callAllLeads(value),
              cursorColor: Theme.of(context).colorScheme.secondary,
              decoration: InputDecoration(
                hintText: "Search ",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: MediaQuery.of(context).size.width * 0.005,
                  ),
                ),
              ),
            ),
          ),
          sizedBoxH10(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [filter("Language"), filter("Country")],
          ),
          sizedBoxH5(context),
        ],
      ),
    );
  }
}
