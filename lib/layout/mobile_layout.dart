import 'package:flutter/material.dart';
import 'package:observer/screens/login_screen.dart';
import 'package:observer/screens/register_screen.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const Scaffold(
    //   body: Center(
    //     child: Text('Mobile is not supported yet.'),
    //   ),
    // );

    return const LoginScreen();
  }
}
