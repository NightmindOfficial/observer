import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/widgets/mobile_account_control.dart';
import 'package:observer/widgets/mobile_navigation.dart';

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
      endDrawer: const MobileAccountControl(),
      endDrawerEnableOpenDragGesture: false,
      appBar: MobileNavigation(pageIndex: _pageIndex),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: setPage,
        children: [
          ...navigationItems.map((item) {
            return item['body'];
          }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: accentColor,
        selectedIconTheme: const IconThemeData(
          color: primaryColor,
        ),
        unselectedIconTheme: const IconThemeData(
          color: secondaryColor,
        ),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        // unselectedLabelStyle: const TextStyle(
        //   color: secondaryColor,
        //   fontWeight: FontWeight.w300,
        //   fontSize: 14,
        // ),
        backgroundColor: mobileBackgroundColor,
        currentIndex: _pageIndex,
        iconSize: 28,
        showUnselectedLabels: false,
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
