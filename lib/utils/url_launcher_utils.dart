import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:tournament_app/widgets/show_snackbar.dart';

class UrlLauncherUtils {
  static Future<void> launchVideoUrl(BuildContext context, String url) async {
    debugPrint('Attempting to launch URL: $url');

    if (url.isEmpty) {
      debugPrint('URL is empty!');
      showSnackBarMessage(
        context,
        'Video URL is not available',
        type: SnackBarType.error,
      );
      return;
    }

    final Uri uri = Uri.parse(url);

    try {
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.externalApplication,
        );
      } else {
        showSnackBarMessage(
          context,
          'Could not launch the video',
          type: SnackBarType.error,
        );
      }
    } catch (e) {
      showSnackBarMessage(
        context,
        'Error launching video: $e',
        type: SnackBarType.error,
      );
    }
  }
}
