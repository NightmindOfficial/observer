import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/helpers/no_glow.dart';
import 'package:observer/helpers/size_guide.dart';
import 'package:observer/layout/dense_web_layout.dart';
import 'package:observer/layout/mobile_layout.dart';
import 'package:observer/layout/responsive_layout.dart';
import 'package:observer/layout/web_layout.dart';
import 'package:observer/resources/authentication.dart';
import 'package:observer/screens/login_screen.dart';
import 'package:observer/utils/snackbar_creator.dart';
import 'package:observer/utils/utils.dart';
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
  final TextEditingController _nameController = TextEditingController();
  ButtonState _buttonState = ButtonState.init;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
    _passController.dispose();
    _nameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void triggerSignUp() async {
    setState(() {
      _buttonState = ButtonState.loading;
    });

    String computationResult = await Authentication().signUpUser(
      email: _mailController.text,
      name: _nameController.text,
      passphrase: _passController.text,
      profilepic: _image,
    );

    setState(() {
      if (computationResult == "Observer node created successfully.") {
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
      snackbarIntent: computationResult == "Observer node created successfully."
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
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              SvgPicture.asset(
                "assets/svg/logo.svg",
                height:
                    proportionateScreenHeightFraction(ScreenFraction.onetenth),
                color: accentColor,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "New Observer Node",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //Picture
              const SizedBox(height: 64),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 48,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(
                              'https://firebasestorage.googleapis.com/v0/b/om-observer.appspot.com/o/observerProfiles%2FRZ9pseTFLuWci4ZwfJqStV3ozzf2?alt=media&token=fbfc2ec6-7726-401f-9d40-c5c690c5af01'),
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
                          onPressed: () => selectImage(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32.0,
              ),

              Expanded(
                flex: kIsWeb ? 4 : 2,
                child: ScrollConfiguration(
                  behavior: NoGlow(),
                  child: ListView(
                    children: [
                      //email input field
                      TextFieldInput(
                        controller: _nameController,
                        hintText: "Full Name",
                        inputType: TextInputType.name,
                      ),
                      const SizedBox(height: 8),
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
                        label: "Activate Node",
                        onPressed: triggerSignUp,
                        isLoading: _isLoading,
                        isDone: _isDone,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      child: const Text(
                        'Connect with existing Node',
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
