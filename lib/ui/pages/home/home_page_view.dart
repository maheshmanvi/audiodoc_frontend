import 'package:audiodoc/ui/pages/home/desktop_home_page_view.dart';
import 'package:audiodoc/ui/pages/home/home_page_controller.dart';
import 'package:audiodoc/ui/pages/home/mobile_home_page_view.dart';
import 'package:audiodoc/ui/widgets/responsive_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({
    super.key,
  });

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final HomePageController controller;

  @override
  void initState() {
    Get.delete<HomePageController>();
    controller = HomePageController();
    Get.put(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveView(
      mobile: (ctx) => MobileHomePageView(),
      desktop: (ctx) => DesktopHomePageView(),
    );
  }
}
