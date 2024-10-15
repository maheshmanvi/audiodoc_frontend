import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/recording_controller.dart';
import 'pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(RecordingController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.poppinsTextTheme(),
    );

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AudioDoc',
      theme: theme,
      home: HomeView(),
    );
  }
}
