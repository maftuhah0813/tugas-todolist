import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tentang Aplikasi',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Aplikasi ini dibuat untuk mengelola tugas harian dengan lebih mudah.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
