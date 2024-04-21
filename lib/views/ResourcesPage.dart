import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services library for Clipboard


class ResourcesPage extends StatelessWidget {
  ResourcesPage({super.key});

  // Define a list of maps where each map contains the title and link of a resource
  final List<Map<String, String>> resources = [
    {'title': 'LAPD Community Safety Partnership', 'link': 'https://www.lapdcsp.org/'},
    {'title': 'Housing Authority of the City of Los Angeles', 'link': 'https://www.hacla.org/en'},
    {'title': 'Los Angeles Department of Recreation and Parks', 'link': 'https://www.laparks.org/'},
    {'title': 'Los Angeles County Library', 'link': 'https://lacountylibrary.org/'},
    {'title': 'City of Los Angeles Government', 'link': 'https://lacity.gov/government'},
    {'title': 'Los Angeles County Department of Mental Health', 'link': 'https://dmh.lacounty.gov/'},
    {'title': 'California Department of Healthcare Services', 'link': 'https://www.ca-med.org/'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/Background2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: resources.map((resource) {
            return Card(
              child: ListTile(
                title: Text(resource['title']!), // Access the title from the map
                subtitle: const Text('Click to Copy'),
                onTap: () {
                  _copyToClipboard(resource['link']!, context);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _copyToClipboard(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied link to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
