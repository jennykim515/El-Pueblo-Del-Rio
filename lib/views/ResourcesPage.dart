import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services library for Clipboard


class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

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
          children: [
            Card(
              child: ListTile(
                title: const Text('Resource 1'),
                subtitle: const Text('Link of Resource 1. Click to Copy'),
                onTap: () {
                  _copyToClipboard('Link of Resource 2. Click to Copy', context);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Resource 2'),
                subtitle: const Text('Link of Resource 2. Click to Copy'),
                onTap: () {
                  _copyToClipboard('Link of Resource 2. Click to Copy', context);
                },
              ),
            ),
            // Add more Card widgets for additional resources
          ],
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
