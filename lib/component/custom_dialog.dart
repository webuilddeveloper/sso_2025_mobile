import 'package:flutter/material.dart';

enum SSODialogType {
  success,
  error,
  warning,
  info,
  confirm,
}

Future<bool?> showSSODialog(
  BuildContext context, {
  required String title,
  String? message,
  SSODialogType type = SSODialogType.success,
  String confirmText = 'ตกลง',
  VoidCallback? onConfirm,
  bool showCancel = false,
  String cancelText = 'ยกเลิก',
  VoidCallback? onCancel,
  bool barrierDismissible = true,
}) {
  Color iconColor;
  Color iconBgColor;
  IconData iconData;

  switch (type) {
    case SSODialogType.success:
      iconColor = const Color(0xFF2E7D32);
      iconBgColor = const Color(0xFFE8F5E9);
      iconData = Icons.check_circle_rounded;
      break;
    case SSODialogType.error:
      iconColor = const Color(0xFFD32F2F);
      iconBgColor = const Color(0xFFFFEBEE);
      iconData = Icons.cancel_rounded;
      break;
    case SSODialogType.warning:
      iconColor = const Color(0xFFF57C00);
      iconBgColor = const Color(0xFFFFF3E0);
      iconData = Icons.warning_rounded;
      break;
    case SSODialogType.info:
      iconColor = const Color(0xFF005C9E);
      iconBgColor = const Color(0xFFE8F0F6);
      iconData = Icons.info_rounded;
      break;
    case SSODialogType.confirm:
      iconColor = const Color(0xFF005C9E);
      iconBgColor = const Color(0xFFE8F0F6);
      iconData = Icons.help_outline_rounded;
      break;
  }

  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: iconColor, size: 38),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF102F30),
                ),
              ),
              if (message != null && message.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 14,
                    color: Color(0xFF646464),
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              if (showCancel)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                          if (onCancel != null) onCancel();
                        },
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005C9E),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                          if (onConfirm != null) onConfirm();
                        },
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005C9E),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                      if (onConfirm != null) onConfirm();
                    },
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
