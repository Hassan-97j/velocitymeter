import 'package:flutter/material.dart';
import 'package:velocitymeter/screens/components/meterpainter.dart';

class Speedometer extends StatelessWidget {
  const Speedometer({
    Key? key,
    required this.speed,
    required this.speedRecord,
    this.size = 300,
  }) : super(key: key);

  final double speed;
  final double speedRecord;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: SpeedometerPainter(speed: speed, speedRecord: speedRecord,),
        size: Size(size, size));
  }
}
