import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HeartLoader extends StatefulWidget {
  const HeartLoader({super.key});

  @override
  State<HeartLoader> createState() => _HeartLoaderState();
}

class _HeartLoaderState extends State<HeartLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // speed of drawing
    )..repeat(reverse: false); // baar-baar draw hota rahe

    _progress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(100, 100), // heart size
            painter: HeartPainter(progress: _progress.value),
          );
        },
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final double progress;
  HeartPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          6 // 👈 stroke set to 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    double w = size.width;
    double h = size.height;

    // Heart shape path
    path.moveTo(w / 2, h * 0.75);
    path.cubicTo(
      w * 1.2,
      h * 0.45, // right curve
      w * 0.8,
      h * 1.2,
      w / 2,
      h * 0.9,
    );
    path.cubicTo(
      w * 0.2,
      h * 1.2, // left curve
      -w * 0.2,
      h * 0.45,
      w / 2,
      h * 0.75,
    );

    // Measure path
    final pathMetrics = path.computeMetrics();
    final Path drawPath = Path();

    for (ui.PathMetric metric in pathMetrics) {
      final extractLength = metric.length * progress;
      drawPath.addPath(metric.extractPath(0, extractLength), Offset.zero);
    }

    canvas.drawPath(drawPath, paint);
  }

  @override
  bool shouldRepaint(covariant HeartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
