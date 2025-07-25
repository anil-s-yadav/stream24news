import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:stream24news/features/settings/settings_page.dart';
import 'package:stream24news/utils/services/shared_pref_service.dart';

import '../../utils/componants/my_widgets.dart';
import '../../utils/componants/sizedbox.dart';
import 'list_data/country_data.dart';
import 'select_language.dart';

class SelectCuntory extends StatefulWidget {
  final String commingFrom;
  const SelectCuntory({super.key, this.commingFrom = ""});

  @override
  State<SelectCuntory> createState() => _SelectCuntoryState();
}

class _SelectCuntoryState extends State<SelectCuntory> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> countryList = countries;
  List<Map<String, String>> filteredList = countries;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredList = countryList.where((country) {
        final name = country['name']!.toLowerCase();
        final code = country['code']!.toLowerCase();
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
                "Where do you come from?",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Text(
                  "Select your country of origin. This will help us make the best recommendations for you.",
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
                onSubmitted: (_) => _filterCountries(),
                onChanged: (_) => _filterCountries(),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
                elevation: WidgetStateProperty.all(0),
                hintText: "Search country",
              ),
              sizedBoxH10(context),
              Expanded(
                child: filteredList.isEmpty
                    ? const Center(child: Text("No countries found."))
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final country = filteredList[index];

                          return MyLightContainer(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ListTile(
                              leading: Image.network(
                                country['flag']!,
                                width: 40,
                                height: 30,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.flag_outlined),
                              ),
                              title: Text(country['name']!),
                              subtitle: Text("Code: ${country['code']}"),
                              onTap: () {
                                List<String> nameAndCode = [
                                  country['flag']!,
                                  country['name']!,
                                  country['code']!
                                ];
                                SharedPrefService().setCounty(nameAndCode);
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
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             SettingsPage()));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SelectLanguage(
                                        commingFrom: '',
                                      ),
                                    ),
                                  );
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
