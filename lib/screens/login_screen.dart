import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/widgets/query_button.dart';
import 'package:observer/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  ButtonState buttonState = ButtonState.init;

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoading = (buttonState == ButtonState.loading) ||
        (buttonState == ButtonState.done);
    bool _isDone = buttonState == ButtonState.done;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: proportionateScreenWidthFraction(
                  ScreenFraction.quantile,
                ) *
                5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                "assets/svg/logo.svg",
                height:
                    proportionateScreenHeightFraction(ScreenFraction.onetenth),
                color: accentColor,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "Observer",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //email input field
              const SizedBox(height: 64),
              TextFieldInput(
                controller: _mailController,
                hintText: "Observer ID",
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              //passwd input field
              TextFieldInput(
                controller: _passController,
                hintText: "Passphrase",
                inputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              QueryButton(
                label: "Establish Connection",
                onPressed: () async {
                  log("Executing...");
                  setState(() => buttonState = ButtonState.loading);
                  await Future.delayed(
                    const Duration(seconds: 3),
                  );
                  setState(() => buttonState = ButtonState.done);
                  await Future.delayed(
                    const Duration(seconds: 3),
                  );
                  setState(() => buttonState = ButtonState.init);
                  log("Done.");
                },
                isLoading: _isLoading,
                isDone: _isDone,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
