import 'package:audiodoc/ui/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlOpenUtil {
  static Future<void> openURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    await OpenURI(context, uri);
  }

  static Future<void> OpenURI(BuildContext context, Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackBar.showErrorToast(context, message: 'Failed to Open URL');
    }
  }

  static void downloadFile(BuildContext context, String baseUrl) {
    Uri uri = Uri.parse(baseUrl);
    OpenURI(context, uri);
  }
}
