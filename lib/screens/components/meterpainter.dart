import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeedometerPainter extends CustomPainter {
  SpeedometerPainter({
    required this.speed,
    required this.speedRecord,
    this.size,
    this.canvas,
    this.center,
    this.paintObject,
  });

  final double speed;
  final double speedRecord;

  Size? size;
  Canvas? canvas;
  Offset? center;
  Paint? paintObject;

  @override
  void paint(Canvas canvas, Size size) {
    init(canvas, size);

    drawOuterCircle();
    drawInnerCircle();
    drawMarkers();
    drawSpeedIndicators(size);
    drawNeedle(0.15 + (speedRecord / 100), Colors.white54, size.width / 120);
    drawNeedle(0.15 + (speed / 100), Colors.red, size.width / 70);
    drawNeedleHolder();
    drawSpeed();
  }

  void drawSpeedIndicators(Size size) {
    for (double percentage = 0.15;
        percentage <= 0.85;
        percentage += 4 / (size.width)) {
      drawSpeedIndicator(percentage);
    }

    for (double percentage = 0.15;
        percentage < 0.15 + (speed / 100);
        percentage += 4 / (size.width)) {
      drawSpeedIndicator(percentage, true);
    }
  }

  void drawMarkers() {
    paintObject!.style = PaintingStyle.fill;

    for (double relativeRotation = 0.15;
        relativeRotation <= 0.851;
        relativeRotation += 0.01) {
      double normalizedDouble =
          double.parse((relativeRotation - 0.15).toStringAsFixed(2));
      int normalizedPercentage = (normalizedDouble * 100).toInt();
      bool isBigMarker = normalizedPercentage % 10 == 0;

      drawRotated(relativeRotation, () => drawMarker(isBigMarker));

      if (isBigMarker) {
        drawRotated(
            relativeRotation,
            () => drawSpeedScaleText(
                relativeRotation, normalizedPercentage.toString()));
      }
    }
  }

  void drawSpeedIndicator(double relativeRotation, [bool highlight = false]) {
    paintObject!.shader = null;
    paintObject!.strokeWidth = 1;
    paintObject!.style = PaintingStyle.stroke;
    paintObject!.color = Get.theme.primaryColorDark.withOpacity(0.6);

    if (highlight) {
      paintObject!.color = Color.lerp(
          Colors.yellow, Colors.red, (relativeRotation - 0.15) / 0.7)!;
      paintObject!.style = PaintingStyle.fill;
    }

    Path markerPath = Path()
      ..addRect(Rect.fromLTRB(
          center!.dx - size!.width / 40,
          size!.width - (size!.width / 30),
          center!.dx,
          size!.width - (size!.width / 100)));

    drawRotated(relativeRotation, () {
      canvas!.drawPath(markerPath, paintObject!);
    });
  }

  void init(Canvas canvas, Size size) {
    this.canvas = canvas;
    this.size = size;
    center = size.center(Offset.zero);
    paintObject = Paint();
  }

  void drawNeedleHolder() {
    RadialGradient gradient = RadialGradient(
        colors: [
          Colors.orange,
          Colors.red,
          Colors.red,
          Get.theme.primaryColorDark
        ],
        radius: 1.2,
        stops: const [0.0, 0.7, 0.9, 1.0]);

    paintObject!
      ..color = Colors.blueGrey
      ..shader = gradient.createShader(Rect.fromCenter(
          center: center!, width: size!.width / 20, height: size!.width / 20));

    canvas!
        .drawCircle(size!.center(Offset.zero), size!.width / 15, paintObject!);
  }

  void drawRotated(double angle, Function drawFunction) {
    canvas!.save();
    canvas!.translate(center!.dx, center!.dy);
    canvas!.rotate(angle * pi * 2);
    canvas!.translate(-center!.dx, -center!.dy);
    drawFunction();
    canvas!.restore();
  }

  void drawMarker(bool isBigMarker) {
    paintObject!
      ..color = Colors.red
      ..shader = null;

    Path markerPath = Path()
      ..addRect(Rect.fromLTRB(
        center!.dx - size!.width / (isBigMarker ? 200 : 300),
        center!.dy + (size!.width / 2.2),
        center!.dx + size!.width / (isBigMarker ? 200 : 300),
        center!.dy + (size!.width / (isBigMarker ? 2.5 : 2.35)),
      ));

    canvas!.drawPath(markerPath, paintObject!);
  }

  void drawSpeedScaleText(double rotation, String text) {
    TextSpan span = TextSpan(
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: size!.width / 20),
        text: text);
    TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    textPainter.layout();

    final textCenter = Offset(center!.dx,
        size!.width - (size!.width / 5.5) + (textPainter.width / 2));

    final textTopLeft = Offset(textCenter.dx - (textPainter.width / 2),
        textCenter.dy - (textPainter.height / 2));

    canvas!.save();

    // Rotate the canvas around the position of the text so that the text is oriented properly

    canvas!.translate(textCenter.dx, textCenter.dy);
    canvas!.rotate(-rotation * pi * 2);
    canvas!.translate(-textCenter.dx, -textCenter.dy);

    textPainter.paint(canvas!, textTopLeft);

    canvas!.restore();
  }

  void drawSpeed() {
    TextSpan span = TextSpan(
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: size!.width / 12),
        text: speed.toStringAsFixed(0));

    TextPainter textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    textPainter.layout();

    final textCenter = Offset(
        center!.dx, center!.dy + (size!.width / 10) + (textPainter.width / 2));

    final textTopLeft = Offset(textCenter.dx - (textPainter.width / 2),
        textCenter.dy - (textPainter.width / 2));

    textPainter.paint(canvas!, textTopLeft);
  }

  void drawNeedle(double rotation, Color color, double width) {
    paintObject!
      ..style = PaintingStyle.fill
      ..color = color;

    Path needlePath = Path()
      ..moveTo(center!.dx - width, center!.dy)
      ..lineTo(center!.dx + width, center!.dy)
      ..lineTo(center!.dx, center!.dy + size!.width / 2.5)
      ..moveTo(center!.dx - width, center!.dy);

    drawRotated(rotation, () {
      canvas!.drawPath(needlePath, paintObject!);
    });
  }

  void drawGhostNeedle() {
    if (speedRecord == 0.0) {
      return;
    }

    double rotation = 0.15 + (speedRecord / 100);

    paintObject!.color = Get.theme.primaryColorDark.withOpacity(0.5);

    Path needlePath = Path()
      ..moveTo(center!.dx - size!.width / 120, center!.dy)
      ..lineTo(center!.dx + size!.width / 120, center!.dy)
      ..lineTo(center!.dx, center!.dy + size!.width / 3)
      ..moveTo(center!.dx - size!.width / 120, center!.dy);

    drawRotated(rotation, () {
      canvas!.drawPath(needlePath, paintObject!);
    });
  }

  void drawInnerCircle() {
    paintObject!
      ..color = Colors.red.withOpacity(0.4)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas!
        .drawCircle(size!.center(Offset.zero), size!.width / 4, paintObject!);
  }

  void drawOuterCircle() {
    paintObject!
      ..color = Colors.red
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas!
        .drawCircle(size!.center(Offset.zero), size!.width / 2.2, paintObject!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
