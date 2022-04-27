import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/layout/mobile_layout.dart';
import 'package:observer/layout/responsive_layout.dart';
import 'package:observer/layout/web_layout.dart';
import 'package:observer/resources/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: accentColor,
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      title: 'Flutter Demo',
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileLayout(),
        webScreenLayout: WebLayout(),
      ),
    );
  }
}
