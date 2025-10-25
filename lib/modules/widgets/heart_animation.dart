import 'dart:math';
import 'package:flutter/material.dart';

/// ---------- HeartPainter ----------
class HeartPainter extends CustomPainter {
  final Color color;

  HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, height * 0.25);
    path.cubicTo(
      width * 0.1,
      height * 0.1,
      width * 0.1,
      height * 0.4,
      width / 2,
      height * 0.7,
    );
    path.cubicTo(
      width * 0.9,
      height * 0.4,
      width * 0.9,
      height * 0.1,
      width / 2,
      height * 0.25,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ---------- Individual animated heart widget ----------
class HeartParticle extends StatefulWidget {
  final Offset startOffset; // fractional offset (0..1)
  final double size; // base size
  final Color color;
  final Duration delay;
  final Duration duration;
  final double verticalRange; // how much it floats vertically (in pixels)

  const HeartParticle({
    super.key,
    required this.startOffset,
    required this.size,
    required this.color,
    required this.delay,
    required this.duration,
    this.verticalRange = 40,
  });

  @override
  State<HeartParticle> createState() => _HeartParticleState();
}

class _HeartParticleState extends State<HeartParticle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _yAnim; // slight vertical bob

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    // scale: slowly bloat (repeat with reverse)
    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.8,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    // gentle fade in/out so not all hearts are visible at peak at same time
    _fadeAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween(0.9), weight: 60),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    // vertical bobbing: -verticalRange/2 .. +verticalRange/2
    _yAnim = Tween<double>(
      begin: -widget.verticalRange / 2,
      end: widget.verticalRange / 2,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

    // stagger start with delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        // repeat with reverse so it breathes
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fractional translation uses Align + Transform.translate to move by y pixels
    return Align(
      alignment: FractionalOffset(widget.startOffset.dx, widget.startOffset.dy),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = _scaleAnim.value;
          final opacity = _fadeAnim.value;
          final yShift = _yAnim.value;
          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, yShift),
              child: Transform.scale(
                scale: scale,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CustomPaint(
                    painter: HeartPainter(color: widget.color),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ---------- Field that spawns multiple hearts across the full page ----------
class HeartField extends StatelessWidget {
  final int count;
  final List<Color> colors;
  final double minDistanceFraction; // minimum distance between hearts (0..1)

  const HeartField({
    super.key,
    this.count = 20,
    this.colors = const [Color(0xFFDF314D), Color(0xFFFFC0CB)],
    this.minDistanceFraction = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    final rnd = Random();
    final media = MediaQuery.of(context).size;
    final availableWidth = media.width;
    final availableHeight = media.height;

    // generate fractional positions (0..1, 0..1) while enforcing minDistanceFraction
    List<Offset> positions = [];
    const int maxAttempts = 5000;
    int attempts = 0;

    while (positions.length < count && attempts < maxAttempts) {
      attempts++;
      // full page coverage: allow anywhere 0..1 for both x and y
      final fx = rnd.nextDouble();
      final fy = rnd.nextDouble();
      final candidate = Offset(fx, fy);

      bool ok = true;
      for (final p in positions) {
        final dx = (p.dx - candidate.dx).abs();
        final dy = (p.dy - candidate.dy).abs();
        // use Euclidean distance on fractional space to decide closeness
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < minDistanceFraction) {
          ok = false;
          break;
        }
      }

      if (ok) positions.add(candidate);
    }

    // if we exhausted attempts and didn't reach count, we'll still render what we have

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: List.generate(positions.length, (i) {
            final pos = positions[i];
            final size = 16 + rnd.nextDouble() * 34; // 16..50
            final color = colors[rnd.nextInt(colors.length)];
            final delayMs = (rnd.nextDouble() * 3000).round();
            final durMs = 4000 + (rnd.nextDouble() * 5000).round();
            final verticalRange =
                (availableHeight / 14) * (0.7 + rnd.nextDouble() * 0.9);

            return HeartParticle(
              startOffset: pos,
              size: size,
              color: color,
              delay: Duration(milliseconds: delayMs),
              duration: Duration(milliseconds: durMs),
              verticalRange: verticalRange,
            );
          }),
        ),
      ),
    );
  }
}
