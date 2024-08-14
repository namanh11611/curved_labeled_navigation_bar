import 'dart:io';
import 'package:flutter/material.dart';

class NavCustomPainter extends CustomPainter {
  late double loc;
  late double bottom;
  Color color;
  Gradient? gradient; // Make gradient optional
  bool hasLabel;
  double? curveDepth; // Make curve depth optional
  double? curveWidthScale; // Make curve width scale optional
  TextDirection textDirection;
  BorderRadius? borderRadius; // Add border radius parameter
  double horizontalContentPadding; // Add horizontal content padding parameterC
  NavCustomPainter({
    required double startingLoc,
    required int itemsLength,
    required this.color,
    this.curveDepth,
    this.gradient, // Accept gradient as an optional parameter
    required this.textDirection,
    this.hasLabel = false,
    this.curveWidthScale,
    this.horizontalContentPadding =
        0, // Accept horizontal content padding as an optional parameter
    this.borderRadius, // Accept border radius as an optional parameter
  }) {
    curveWidthScale = curveWidthScale ?? 0.2; // Default value if not provided
    final span = 1.0 / itemsLength;
    final l = startingLoc + (span - curveWidthScale!) / 2;
    loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    bottom = curveDepth ??
        (hasLabel
            ? (Platform.isAndroid ? 0.55 : 0.45)
            : (Platform.isAndroid ? 0.6 : 0.5));
  }

  @override
  void paint(Canvas canvas, Size size) {
    Size customSize =
        Size(size.width - 2 * horizontalContentPadding, size.height);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;

    // Use gradient if provided, otherwise use solid color
    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    // Create the rounded rectangle
    final roundedRect = RRect.fromRectAndCorners(
      rect,
      topLeft: borderRadius?.topLeft ?? Radius.zero,
      topRight: borderRadius?.topRight ?? Radius.zero,
      bottomLeft: borderRadius?.bottomLeft ?? Radius.zero,
      bottomRight: borderRadius?.bottomRight ?? Radius.zero,
    );

    // Clip the canvas to the rounded rectangle
    canvas.clipRRect(roundedRect);

    // Create path for the custom shape
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(customSize.width * (loc - 0.05) + horizontalContentPadding,
          0) // Adjust left side of notch
      ..cubicTo(
        customSize.width * (loc + curveWidthScale! * 0.2) +
            horizontalContentPadding, // topX
        customSize.height * 0.05, // topY
        customSize.width * loc + horizontalContentPadding, // bottomX
        customSize.height * bottom, // bottomY
        customSize.width * (loc + curveWidthScale! * 0.5) +
            horizontalContentPadding, // centerX
        customSize.height * bottom, // centerY
      )
      ..cubicTo(
        customSize.width * (loc + curveWidthScale!) +
            horizontalContentPadding, // bottomX
        customSize.height * bottom, // bottomY
        customSize.width * (loc + curveWidthScale! * 0.8) +
            horizontalContentPadding, // topX
        customSize.height * 0.05, // topY
        customSize.width * (loc + curveWidthScale! + 0.05) +
            horizontalContentPadding, // Adjust right side of notch
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    // Draw the path
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
