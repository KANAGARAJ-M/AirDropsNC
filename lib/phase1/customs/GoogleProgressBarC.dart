import 'dart:math';
import 'package:flutter/material.dart';

class GoogleColorChangingProgressBar extends StatefulWidget {
  const GoogleColorChangingProgressBar({super.key});

  @override
  _GoogleColorChangingProgressBarState createState() =>
      _GoogleColorChangingProgressBarState();
}

class _GoogleColorChangingProgressBarState
    extends State<GoogleColorChangingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Loop duration
      vsync: this,
    )..repeat(); // Continuous loop

    // Animation for rotation (0 to 360 degrees)
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Animation for color change with multiple color transitions
    _colorAnimation = TweenSequence<Color?>(
      [
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.blue, end: Colors.red),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.red, end: Colors.green),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.green, end: Colors.yellow),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.yellow, end: Colors.blue),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.blue, end: Colors.orange),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.orange, end: Colors.grey),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.grey, end: Colors.deepPurple),
        ),
        TweenSequenceItem(
          weight: 3,
          tween: ColorTween(begin: Colors.deepPurple, end: Colors.blue),
        ),
      ],
    ).animate(_controller);
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
          painter: GoogleStyleCircularPainter(
            rotation: _rotationAnimation.value,
            color: _colorAnimation.value!,
          ),
          child: const SizedBox(
            width: 50,
            height: 50,
          ),
        );
      },
    );
  }
}

class GoogleStyleCircularPainter extends CustomPainter {
  final double rotation;
  final Color color;

  GoogleStyleCircularPainter({required this.rotation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    double startAngle = rotation; // Rotate the arc
    double sweepAngle = pi * 1.5; // 75% of the circle

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
