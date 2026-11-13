import 'package:flutter/material.dart';
import 'package:sso/component/loading_tween.dart';

String sanitizeImageUrl(String url) {
  if (url.isEmpty) return '';

  // Rewrite legacy document subdomain lc.we-builds.com to active gateway.we-builds.com
  var cleanUrl = url
      .replaceAll('http://lc.we-builds.com', 'https://gateway.we-builds.com')
      .replaceAll('https://lc.we-builds.com', 'https://gateway.we-builds.com');

  // Upgrade http to https for we-builds.com domains
  if (cleanUrl.startsWith('http://') && cleanUrl.contains('we-builds.com')) {
    cleanUrl = cleanUrl.replaceFirst('http://', 'https://');
  }

  return cleanUrl;
}

Widget loadingImageNetwork(
  String rawUrl, {
  BoxFit? fit,
  double? height,
  double? width,
  Color? color,
  bool isProfile = false,
}) {
  final url = sanitizeImageUrl(rawUrl);

  if (url.isEmpty) {
    if (isProfile) {
      return Container(
        height: height ?? 80,
        width: width ?? 80,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0F6),
          shape: BoxShape.circle,
          border: Border.all(
            width: 1.5,
            color: const Color(0xFF005C9E).withOpacity(0.25),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.person,
            size: (height != null) ? (height * 0.55) : 44,
            color: const Color(0xFF005C9E),
          ),
        ),
      );
    }
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image_outlined, color: Colors.grey[400], size: 36),
    );
  }

  return Image.network(
    url,
    fit: fit ?? BoxFit.cover,
    height: height,
    width: width,
    color: color,
    loadingBuilder: (
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    ) {
      if (loadingProgress == null) return child;
      return LoadingTween(height: height ?? 30.0, width: width ?? 30.0);
    },
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      if (isProfile) {
        return Container(
          height: height ?? 80,
          width: width ?? 80,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0F6),
            shape: BoxShape.circle,
            border: Border.all(
              width: 1.5,
              color: const Color(0xFF005C9E).withOpacity(0.25),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              size: (height != null) ? (height * 0.55) : 44,
              color: const Color(0xFF005C9E),
            ),
          ),
        );
      }
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 36),
      );
    },
  );
}
