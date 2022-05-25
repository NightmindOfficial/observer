import 'package:flutter/material.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/models/observer.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:provider/provider.dart';

class AccountAvatar extends StatelessWidget {
  final bool link;
  const AccountAvatar({Key? key, this.link = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Observer observer = Provider.of<ObserverProvider>(context).observer;

    return Center(
      child: GestureDetector(
        onTap: link ? () => Scaffold.of(context).openEndDrawer() : () {},
        child: SizedBox(
          height: customAppBarSize * mobileAccountWidgetFraction,
          child: ClipRRect(
            child: Image.network(
              observer.profilePictureURL,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                }
              },
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(
                customAppBarSize * mobileAccountWidgetFraction / 2),
          ),
        ),
      ),
    );
  }
}
