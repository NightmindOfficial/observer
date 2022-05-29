import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:observer/helpers/colors.dart';
import 'package:observer/layout/dense_web_layout.dart';
import 'package:observer/layout/mobile_layout.dart';
import 'package:observer/layout/responsive_layout.dart';
import 'package:observer/layout/web_layout.dart';
import 'package:observer/providers/observer_provider.dart';
import 'package:observer/providers/workspace_provider.dart';
import 'package:observer/resources/firebase_options.dart';
import 'package:observer/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
  //   SystemUiOverlay.bottom, //This line is used for showing the bottom bar
  // ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ObserverProvider>(
          create: (_) => ObserverProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkspaceProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: accentColor,
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        title: 'Observer',
        home: StreamBuilder(
          // stream: FirebaseAuth.instance.idTokenChanges(), // Listen to any user changes INCLUDING cross-platform installs
          // stream: FirebaseAuth.instance.userChanges(), //Listen to any user changes INCLUDING parameter updates (e.g. password update etc.)
          stream: FirebaseAuth.instance
              .authStateChanges(), //Listen to signins and signouts, nothing more.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileLayout(),
                  webScreenLayout: WebLayout(),
                  smallScreenLayout: DenseWebLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
