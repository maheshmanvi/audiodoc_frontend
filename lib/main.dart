import 'package:audiodoc/infrastructure/di.dart';
import 'package:audiodoc/infrastructure/env.dart';
import 'package:audiodoc/ui/app_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.hardcoded();

  inject();

  runApp(AppView());

  /* Get.put(RecordingController());
  runApp(MyApp());*/
}

/*
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
*/
