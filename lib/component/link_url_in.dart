// ignore_for_file: unnecessary_import

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

launchInWebViewWithJavaScript(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
