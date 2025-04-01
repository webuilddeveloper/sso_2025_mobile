import 'package:flutter/material.dart';
import 'package:sso/component/loading_tween.dart';

Widget loadingImageNetwork(
  String url, {
  BoxFit? fit,
  double? height,
  double? width,
  Color? color,
  bool isProfile = false,
}) {
  if (url.isEmpty) {
    if (isProfile) {
      return Container(
        height: height ?? 30,
        width: width ?? 30,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          'assets/images/user_not_found.png',
          color: Colors.white,
          fit: BoxFit.cover,
        ),
      );
    }
    return LoadingTween(height: height, width: width);
  }

  return Image.network(
    url,
    fit: fit,
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
      return LoadingTween(height: height, width: width);
    },
  );
}
