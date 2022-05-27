import 'package:flutter/material.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/global_variables.dart';

class QueryButton extends StatefulWidget {
  final bool isLoading;
  final bool isDone;
  final void Function() onPressed;
  final Widget? child;
  final double height;
  const QueryButton({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.isLoading,
    this.isDone = false,
    this.height = 48,
  }) : super(key: key);

  @override
  State<QueryButton> createState() => _QueryButtonState();
}

class _QueryButtonState extends State<QueryButton> {
  final double width = 350;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: !widget.isLoading
          ? buildButton(onPressed: widget.onPressed, child: widget.child)
          : buildLoadingButton(
              isDone: widget.isDone,
            ),
      height: widget.height,
      width: widget.isLoading ? widget.height : width,
    );
  }
}

Widget buildButton({
  required void Function() onPressed,
  required Widget? child,
}) {
  return ElevatedButton(
    autofocus: true,
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      elevation: 0,
      primary: accentColor,
      padding: EdgeInsets.zero,
      splashFactory: NoSplash.splashFactory,
      textStyle: buttonTextStyle,
    ),
    onPressed: onPressed,
    child: child,
  );
}

Widget buildLoadingButton({
  bool isDone = false,
}) {
  final boxColor = isDone ? Colors.green : accentColor;

  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      primary: boxColor,
      padding: EdgeInsets.zero,
      textStyle: buttonTextStyle,
    ),
    child: Center(
      child: isDone
          ? const Icon(
              Icons.done_rounded,
              size: 36,
              color: primaryColor,
            )
          : const CircularProgressIndicator(
              color: mobileSearchColor,
              strokeWidth: 5,
            ),
    ),
  );
}

enum ButtonState {
  init,
  loading,
  done,
}
