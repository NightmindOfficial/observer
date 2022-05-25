import 'package:flutter/material.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/screens/core/subjects_screen.dart';

const webScreenSize = 1024;

const List<Map<String, dynamic>> navigationItems = [
  {
    'title': "All Subjects",
    'body': SubjectsScreen(),
  },
  {
    // 'title': "Ledger",
    'body': Center(child: Text("Ledger Screen")),
  },
  {
    'title': "Attach To Network",
    'body': Center(child: Text("Attach Screen")),
  },
  {
    'title': "Network",
    'body': Center(child: Text("Network Screen")),
  },
];

double customAppBarSize =
    proportionateScreenHeightFraction(ScreenFraction.onetenth);

double mobileAccountWidgetFraction = 2 / 3;
