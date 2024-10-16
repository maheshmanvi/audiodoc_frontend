import 'package:audiodoc/resources/app_strings.dart';
import 'package:audiodoc/theme/app_theme.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/material.dart';

class AppView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
      routerDelegate: goRouter.routerDelegate,
      theme: AppTheme.getTheme(),
    );
  }

}
