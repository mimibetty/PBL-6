import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'English'; 
  void _changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Selection'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text(
            //   'Select Language',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
            SizedBox(height: 32),
            _buildLanguageOption('English'),
            SizedBox(height: 16),
            _buildLanguageOption('Vietnamese'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      leading: Radio<String>(
        value: language,
        groupValue: selectedLanguage,
        onChanged: (value) {
          if (value != null) {
            _changeLanguage(value);
          }
        },
      ),
      onTap: () {
        _changeLanguage(language);
      },
    );
  }
}
