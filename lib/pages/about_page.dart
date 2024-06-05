import 'package:flutter/material.dart';
import 'package:myapp/components/dope_box.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('A B O U T')),
        body: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          child: const Column(children: [
            SizedBox(height: 20),
            Center(
              child: DopeBox(child: Text('bxmedia@proton.me')),
            ),
          ]),
        ));
  }
}
