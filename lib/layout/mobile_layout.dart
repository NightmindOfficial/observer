import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    ObserverProvider _observer = Provider.of<ObserverProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as ${_observer.observer.name}"),
            Text("Observer ID: ${_observer.observer.uid}"),
            const SizedBox(
              height: 32.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: accentColor,
              ),
              onPressed: () {
                _auth.signOut();
              },
              child: const Text("Log Out"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        iconSize: 26,
        selectedFontSize: 14,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: "Subjects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: "Ledger",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Attach",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hub_rounded),
            label: "Network",
          ),
        ],
        onTap: (value) {},
      ),
    );
    // return const HomeScreen();
  }
}
