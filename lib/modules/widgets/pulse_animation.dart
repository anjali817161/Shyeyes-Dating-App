import 'package:flutter/material.dart';
import 'dart:math' as math;

class PulseAnimation extends StatefulWidget {
  final double size;
  final Widget child;

  const PulseAnimation({super.key, required this.size, required this.child});

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: PulsePainter(_controller.value),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class PulsePainter extends CustomPainter {
  final double value;
  PulsePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(1 - value)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    double radius = (size.width / 2) * (0.7 + value * 0.3);
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant PulsePainter oldDelegate) => true;
}
