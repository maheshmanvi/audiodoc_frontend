import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/recording_controller.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(RecordingController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AudioDoc',
      home: HomeView(),
    );
  }
}
