import 'package:flutter/material.dart';

class AgriculturalPlaneIcon extends StatelessWidget {
  final double size;
  final Color color;

  const AgriculturalPlaneIcon({
    super.key,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.15,
      child: Icon(
        Icons.flight,
        size: size,
        color: color,
      ),
    );
  }
}
