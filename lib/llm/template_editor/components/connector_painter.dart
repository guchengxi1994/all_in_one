import 'package:flutter/material.dart';

class ConnectorPainter extends CustomPainter {
  final List<(Offset, Offset)> bounds;
  final double radius;
  final Color color;

  ConnectorPainter({
    required this.bounds,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // 线条颜色
      ..strokeWidth = 2; // 线条宽度

    for (final point in bounds) {
      final startPoint = point.$1;
      final endPoint = point.$2;

      Path path = Path()
        ..moveTo(startPoint.dx, startPoint.dy)
        ..lineTo(startPoint.dx - 10, startPoint.dy - 10)
        ..lineTo(startPoint.dx - 10, startPoint.dy + 10)
        ..close();

      Path path2 = Path()
        ..moveTo(endPoint.dx, endPoint.dy)
        ..lineTo(endPoint.dx - 10, endPoint.dy - 10)
        ..lineTo(endPoint.dx - 10, endPoint.dy + 10)
        ..close();

      final left1 = Offset(startPoint.dx / 2, startPoint.dy);
      final left2 = Offset(endPoint.dx / 2, endPoint.dy);

      canvas.drawPath(path, paint);
      canvas.drawLine(startPoint, left1, paint);
      canvas.drawLine(left1, left2, paint);
      canvas.drawLine(left2, endPoint, paint);
      canvas.drawPath(path2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
