import 'package:audiodoc/ui/pages/home/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopHomePageView extends GetView<HomePageController> {
  const DesktopHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => controller.startRecording(context),
        child: Text('Start Recording'),
      ),
    );
  }
}