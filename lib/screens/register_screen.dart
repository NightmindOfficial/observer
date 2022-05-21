import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/widgets/query_button.dart';
import 'package:observer/widgets/text_field_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                "Create new Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //Picture
              const SizedBox(height: 64),
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1653045270357-f802a1de3855?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=80&raw_url=true&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: accentColor,
                      radius: 16,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.photo_library,
                            color: mobileSearchColor,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),

              //email input field
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
                label: "Add to Mainframe",
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
