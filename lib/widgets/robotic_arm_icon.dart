import 'package:flutter/material.dart';

class RoboticArmIcon extends StatelessWidget {
  final double size;
  final Color color;

  const RoboticArmIcon({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RoboticArmPainter(color: color),
      ),
    );
  }
}

class _RoboticArmPainter extends CustomPainter {
  final Color color;

  _RoboticArmPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.085
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // 1. Base Stand
    canvas.drawLine(
      Offset(w * 0.05, h * 0.88),
      Offset(w * 0.52, h * 0.88),
      paint..strokeWidth = w * 0.1,
    );

    // 2. Base Joint Pivot
    canvas.drawCircle(Offset(w * 0.28, h * 0.84), w * 0.06, fillPaint);

    // 3. Lower Support Beam
    canvas.drawLine(
      Offset(w * 0.28, h * 0.84),
      Offset(w * 0.16, h * 0.44),
      paint..strokeWidth = w * 0.08,
    );

    // 4. Middle Joint
    canvas.drawCircle(Offset(w * 0.16, h * 0.44), w * 0.06, fillPaint);

    // 5. Forearm Link
    canvas.drawLine(
      Offset(w * 0.16, h * 0.44),
      Offset(w * 0.60, h * 0.38),
      paint..strokeWidth = w * 0.08,
    );

    // 6. Wrist Joint
    canvas.drawCircle(Offset(w * 0.60, h * 0.38), w * 0.05, fillPaint);

    // 7. Mechanical Gripper / Claws
    final clawPath = Path()
      ..moveTo(w * 0.60, h * 0.38)
      ..lineTo(w * 0.74, h * 0.28)
      ..lineTo(w * 0.88, h * 0.32)
      ..moveTo(w * 0.60, h * 0.38)
      ..lineTo(w * 0.74, h * 0.48)
      ..lineTo(w * 0.88, h * 0.44);

    canvas.drawPath(clawPath, paint..strokeWidth = w * 0.075);
  }

  @override
  bool shouldRepaint(covariant _RoboticArmPainter oldDelegate) =>
      oldDelegate.color != color;
}
