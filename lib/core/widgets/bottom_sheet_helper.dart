import 'package:flutter/material.dart';

class BottomSheetHelper {
  static void show({
    required BuildContext context,
    required Widget child,
    double? minHeight,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        final minimumHeight = minHeight ?? screenHeight / 2;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 8,
              width: 64,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: screenWidth,
              constraints: BoxConstraints(minHeight: minimumHeight, maxWidth: screenWidth),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
