import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/utils/snackbar_creator.dart';

class WebLayout extends StatelessWidget {
  const WebLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Web is not supported yet.'),
            const Text('Please check back soon.'),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                await _auth.signOut().then(
                      (_) => showSnackbar(
                          "Signed out from the Observer Network.", context),
                    );
              },
              style: ElevatedButton.styleFrom(
                primary: accentColor,
              ),
              child: const Text(
                "Sign out",
                style: TextStyle(
                  color: mobileBackgroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
