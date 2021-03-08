import 'package:flutter/material.dart';

class LandingPagePainter extends CustomPainter {
  LandingPagePainter({this.color});
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = color!
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.63, 0);
    path_0.quadraticBezierTo(size.width * 0.56, size.height * -0.01,
        size.width * 0.55, size.height * 0.09);
    path_0.cubicTo(size.width * 0.53, size.height * 0.22, size.width * 0.63,
        size.height * 0.37, size.width * 0.62, size.height * 0.49);
    path_0.cubicTo(size.width * 0.61, size.height * 0.58, size.width * 0.43,
        size.height * 0.72, size.width * 0.42, size.height * 0.98);
    path_0.quadraticBezierTo(size.width * 0.42, size.height * 0.99,
        size.width * 0.42, size.height * 1.00);
    path_0.lineTo(size.width, size.height * 1.00);
    path_0.lineTo(size.width, 0);

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
