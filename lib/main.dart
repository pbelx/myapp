import 'package:flutter/material.dart';
import 'package:myapp/pages/home_page.dart';
// import 'package:myapp/pages/test.dart';
import 'package:provider/provider.dart';


import 'themes/theme_provider.dart';
void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const Bxradio(),
  ));
}

class Bxradio extends StatelessWidget {
  const Bxradio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  MyWidget(),
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
