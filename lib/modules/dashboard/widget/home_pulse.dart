import 'package:flutter/material.dart';

class HomePulse extends StatefulWidget {
  final double size;
  final Widget child;

  const HomePulse({
    Key? key,
    required this.size,
    required this.child,
  }) : super(key: key);

  @override
  State<HomePulse> createState() => _HomePulseState();
}

class _HomePulseState extends State<HomePulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: HomePulsePainter(
              progress: _controller.value,
              maxSize: widget.size,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class HomePulsePainter extends CustomPainter {
  final double progress;
  final double maxSize;

  HomePulsePainter({
    required this.progress,
    required this.maxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Bigger pulse size:
    final double radius = (maxSize / 2) * (0.8 + progress * 0.4);
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant HomePulsePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.maxSize != maxSize;
  }
}
