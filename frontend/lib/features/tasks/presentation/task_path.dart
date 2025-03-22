import 'package:flutter/material.dart';
import 'dart:math';
import 'package:frontend/core/constants/app_theme.dart';


class TaskPathWidget extends StatelessWidget {
  final List<TaskNode> nodes;

  TaskPathWidget({required this.nodes});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: 100 * (nodes.length + 1),
      child: Stack(
        children: [
          CustomPaint(
            painter: TaskPathPainter(nodes: nodes, width: screenWidth),
          ),
          ..._buildIcons(nodes, screenWidth),
        ],
      )
    );
  }

  List<Widget> _buildIcons(List<TaskNode> nodes, double width) {
    return List.generate(nodes.length, (i) {
      if (!nodes[i].flag) return SizedBox.shrink();
      final double x = width / 2 + (i % 2 == 0 ? -50 : 50);
      final double y = 100 * (i + 1);
      return Positioned(
        left: x + FontConstants.largeHeaderFontSize - (FontConstants.largeHeaderFontSize / 4),
        top: y - FontConstants.largeHeaderFontSize,
        child: Transform.rotate(
          angle: pi / 4,
          child: Icon(Icons.flag, color: Colors.white, size: FontConstants.largeHeaderFontSize),
        ),
      );
    });
  }
}

class TaskNode {
  final String text;
  final Color color;
  final bool flag;

  TaskNode({
    required this.text,
    required this.color,
    this.flag = false
  });
}

class TaskPathPainter extends CustomPainter {
  final List<TaskNode> nodes;
  final double width;

  TaskPathPainter({required this.nodes, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.whiteColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final positions = List.generate(nodes.length, (i) => Offset(
        width / 2 + (i % 2 == 0 ? -50 : 50),
        100 * (i + 1)
    ));
    for (int i = 0; i < positions.length - 1; i++) {
      _drawDashedLine(canvas, paint, positions[i], positions[i + 1]);
    }
    for (int i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      final position = positions[i];
      final circlePaint = Paint()
        ..color = node.color;
      canvas.drawCircle(position, FontConstants.largeHeaderFontSize, circlePaint);
      final textPainter = TextPainter(
        text: TextSpan(
          text: node.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: FontConstants.standardFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    double distance = sqrt(dx * dx + dy * dy);
    double dashLength = 10, gapLength = 5;
    double dashCount = distance / (dashLength + gapLength);

    for (int i = 0; i < dashCount; i++) {
      double x1 = start.dx + (dx / dashCount) * i;
      double y1 = start.dy + (dy / dashCount) * i;
      double x2 = start.dx + (dx / dashCount) * (i + 0.5);
      double y2 = start.dy + (dy / dashCount) * (i + 0.5);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

