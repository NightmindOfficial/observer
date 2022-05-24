import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  late PageController pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void setPage(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: setPage,
        children: naviagtionItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(
          color: primaryColor,
        ),
        unselectedIconTheme: const IconThemeData(
          color: secondaryColor,
        ),
        backgroundColor: mobileBackgroundColor,
        currentIndex: _pageIndex,
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
        onTap: navigationTapped,
      ),
    );
    // return const HomeScreen();
  }
}
