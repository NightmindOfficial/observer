import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/global_variables.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/layout/dense_web_layout.dart';
import 'package:observer/layout/mobile_layout.dart';
import 'package:observer/layout/responsive_layout.dart';
import 'package:observer/layout/web_layout.dart';
import 'package:observer/resources/authentication.dart';
import 'package:observer/screens/auth/register_screen.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/widgets/buttons/query_button.dart';
import 'package:observer/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  ButtonState _buttonState = ButtonState.init;

  void triggerLogin() async {
    setState(() {
      _buttonState = ButtonState.loading;
    });

    String computationResult = await Authentication().signInUser(
      mail: _mailController.text,
      pass: _passController.text,
    );

    setState(() {
      if (computationResult == "Connection to Observer Network established.") {
        _buttonState = ButtonState.done;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileLayout(),
                  webScreenLayout: WebLayout(),
                  smallScreenLayout: DenseWebLayout(),
                )),
          ),
        );
      } else {
        _buttonState = ButtonState.init;
      }
    });

    log(computationResult);
    showSnackbar(
      computationResult,
      context,
      snackbarIntent:
          computationResult == "Connection to Observer Network established."
              ? SnackbarIntent.info
              : SnackbarIntent.error,
    );
    // await Future.delayed(
    //   const Duration(
    //     seconds: 1,
    //   ),
    // );
    // setState(() {
    //   _buttonState = ButtonState.init;
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeGuide().init(context);
    bool _isLoading = (_buttonState == ButtonState.loading) ||
        (_buttonState == ButtonState.done);
    bool _isDone = _buttonState == ButtonState.done;

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
                child: Text(
                  "Establish Connection",
                  style: buttonTextStyle,
                ),
                onPressed: triggerLogin,
                isLoading: _isLoading,
                isDone: _isDone,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    child: Container(
                      child: const Text(
                        'Add Observer Node',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
