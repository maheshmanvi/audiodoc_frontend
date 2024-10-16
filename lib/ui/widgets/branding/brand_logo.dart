import 'package:audiodoc/infrastructure/env.dart';
import 'package:audiodoc/resources/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandLogo extends StatefulWidget {
  const BrandLogo({
    super.key,
  });

  @override
  State<BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<BrandLogo> {
  final Env env = Env.instance;
  late final Uri _uri;

  @override
  void initState() {
    _uri = Uri.parse(env.brandHomePageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!await launchUrl(_uri)) {
          throw Exception('Could not launch $_uri');
        }
      },
      child: Image.asset(
        AppAssets.brandLogo,
        height: 30,
      ),
    );
  }
}
