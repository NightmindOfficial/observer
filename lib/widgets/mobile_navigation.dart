import 'package:flutter/material.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/widgets/account_avatar.dart';

class MobileNavigation extends StatelessWidget with PreferredSizeWidget {
  final int? pageIndex;
  final String fallbackTitle;
  final bool showMobileUAC;
  const MobileNavigation({
    Key? key,
    this.pageIndex,
    this.fallbackTitle = "Error",
    this.showMobileUAC = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            proportionateScreenWidthFraction(ScreenFraction.quantile) * 4,
      ),
      child: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(
            fontSize: preferredSize.height * mobileAccountWidgetFraction / 2),
        toolbarHeight: customAppBarSize,
        title: Text(
          pageIndex != null
              ? navigationItems[pageIndex!]['title'] ??
                  fallbackTitle // TITLE PRIORITY: 1. Use Title provided by pageIndex, 2. Use provided Fallback Title, 3. Show "Error" as Fallback Title
              : fallbackTitle, // Triggers when there is no pageIndex and shows "Error" when no custom fallbackTitle is given
        ),
        actions: [
          if (showMobileUAC) const AccountAvatar(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(customAppBarSize);
}
