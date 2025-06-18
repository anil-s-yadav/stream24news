import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';

import '../../utils/componants/my_widgets.dart';
import '../../utils/componants/sizedbox.dart';
import 'list_data/language_data.dart';
import 'signup_done_page.dart';

class SelectLanguage extends StatefulWidget {
  final String commingFrom;
  const SelectLanguage({super.key, required this.commingFrom});

  @override
  State<SelectLanguage> createState() => _SelectLanguage();
}

class _SelectLanguage extends State<SelectLanguage> {
  final TextEditingController _searchController = TextEditingController();

  final languageList = languages.entries.toList();
  late List<MapEntry<String, String>> filterList;

  @override
  void initState() {
    super.initState();
    filterList = languageList; // Initialize with full list
    _searchController.addListener(_filterLanguages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLanguages() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filterList = languageList.where((language) {
        final name = language.key.toLowerCase();
        final code = language.value.toLowerCase();
        return name.contains(query) || code.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select a language",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02,
                  vertical: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Text(
                  "Select your language. This will help us make the best recommendations for you.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.shadow,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              sizedBoxH10(context),
              SearchBar(
                controller: _searchController,
                onChanged: (_) => _filterLanguages(),
                onSubmitted: (_) => _filterLanguages(),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                elevation: WidgetStateProperty.all(0),
                hintText: "Search language",
              ),
              sizedBoxH10(context),
              Expanded(
                child: filterList.isEmpty
                    ? const Center(child: Text("No languages found."))
                    : ListView.builder(
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          final languageName = filterList[index].key;
                          final languageCode = filterList[index].value;

                          return MyLightContainer(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red.shade100,
                                child: Text(
                                  languageCode.toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(languageName),
                              subtitle: Text("Code: $languageCode"),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                SharedPrefService()
                                    .setLanguage([languageName, languageCode]);
                                if (widget.commingFrom == 'settings') {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Restart App!"),
                                            content: Text(
                                                "For reflect changes restart the App!"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Restart.restartApp(),
                                                  child: Text("Resart"))
                                            ],
                                          ));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupDonePage())); //value is: loginSkip comming from loginoptions page
                                }
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
