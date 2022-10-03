import 'package:flutter/material.dart';
import 'dart:math';
import '../../model/planet.dart';

class SystemPainter extends CustomPainter {
  SystemPainter({
    required this.planets,
    required this.energy,
    required this.impulse,
    required this.width,
    required this.height,
    required this.scale,
    this.xShift = 0,
    this.yShift = 0,
    required this.coordinatesCenter,
  });

  final List<Planet> planets;
  final double width;
  final double height;
  final double scale;
  final double xShift;
  final double yShift;
  final double energy;
  final double impulse;
  int coordinatesCenter;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()..color = Colors.white;
    final planetPaint = Paint()..color = Colors.red;
    canvas.drawPaint(fillPaint);
    final trajectoryPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 1;
    for (Planet planet in planets) {
      for (int i = 0; i < planet.trajectory.length - 1; i++) {
        canvas.drawLine(
          Offset(
            _xToCanvasCoordinates(planet.trajectory.elementAt(i).x),
            _yToCanvasCoordinates(planet.trajectory.elementAt(i).y),
          ),
          Offset(
            _xToCanvasCoordinates(planet.trajectory.elementAt(i + 1).x),
            _yToCanvasCoordinates(planet.trajectory.elementAt(i + 1).y),
          ),
          trajectoryPaint,
        );
      }
      canvas.drawCircle(
        Offset(_xToCanvasCoordinates(planet.position.x),
            _yToCanvasCoordinates(planet.position.y)),
        _massToDiameter(planet.mass),
        planetPaint,
      );
    }

    drawText(
      canvas: canvas,
      text: 'Energy: $energy',
      offset: const Offset(10, 10),
      fontSize: 12,
    );
    drawText(
      canvas: canvas,
      text: 'Impulse: $impulse',
      offset: const Offset(10, 25),
      fontSize: 12,
    );
  }

  void drawText({
    required Canvas canvas,
    required String text,
    required Offset offset,
    double fontSize = 15,
    Color color = Colors.black,
  }) {
    final textSpan = TextSpan(
        text: text, style: TextStyle(color: color, fontSize: fontSize));
    final painter = TextPainter(text: textSpan)
      ..textDirection = TextDirection.ltr;
    painter.layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double _xToCanvasCoordinates(double x) =>
      (x - _xPowShift()) / scale + width / 2 + xShift;

  double _yToCanvasCoordinates(double y) =>
      height / 2 - (y - _yPowShift()) / scale + yShift;

  double _xPowShift() {
    if (coordinatesCenter < 0) {
      return 0;
    }
    return planets.elementAt(coordinatesCenter).position.x;
  }

  double _yPowShift() {
    if (coordinatesCenter < 0) {
      return 0;
    }
    return planets.elementAt(coordinatesCenter).position.y;
  }

  double _massToDiameter(double mass) {
    final diameter = log(mass / 5.972e24) / log(10) * 3;
    if (diameter < 3) {
      return 3;
    }
    return diameter;
  }
}
