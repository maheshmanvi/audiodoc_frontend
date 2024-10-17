import 'package:audiodoc/infrastructure/env.dart';
import 'package:audiodoc/resources/app_assets.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandLogo extends StatefulWidget {

  final bool allowClick;
  const BrandLogo({
    super.key,
    this.allowClick = false,
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
        if(!widget.allowClick) {
          return;
        }
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

class BrandLogoIcon extends StatefulWidget {
  const BrandLogoIcon({
    super.key,
  });

  @override
  State<BrandLogoIcon> createState() => _BrandLogoIconState();
}

class _BrandLogoIconState extends State<BrandLogoIcon> {
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
      child: Text("VIVEKA", style: context.theme.typo.appBarTitle.copyWith(color: context.theme.colors.onPrimary)),
    );
  }
}
