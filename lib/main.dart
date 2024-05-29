import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'helpers/pref.dart';
import 'view/splash_screen.dart';

late Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Pref.initializeHive();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VPN Project',
      home: SplashScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: false,
        scaffoldBackgroundColor: const Color(0XFFF1F6F3),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
