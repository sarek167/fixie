import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_routes.dart';
import 'dart:math';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:frontend/features/tasks/presentation/single_task_screen.dart';


class TaskPathWidget extends StatelessWidget {
  final List<TaskNode> nodes;
  final double spacing;
  final double circleOffset;
  final double nodeSize;

  const TaskPathWidget({
    super.key,
    required this.nodes,
    this.spacing = 100,
    this.circleOffset = 75,
    this.nodeSize = FontConstants.largeHeaderFontSize
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      height: spacing * (nodes.length + 1),
      child: Stack(
        children: [
          CustomPaint(
            painter: TaskPathPainter(nodes: nodes, width: screenWidth, spacing: spacing, circleOffset: circleOffset),
          ),
          ..._buildIcons(nodes, screenWidth, nodeSize),
          ..._buildTappableCircles(context, nodes, screenWidth, nodeSize)
        ],
      )
    );
  }

  List<Widget> _buildTappableCircles(BuildContext context, List<TaskNode> nodes, double width, double size) {
    return List.generate(nodes.length, (i) {
      final node = nodes[i];
      final double x = width / 2 + (i % 2 == 0 ? -circleOffset : circleOffset);
      final double y = spacing * (i + 1);

      if (node.isTrophy) {
        return Positioned(
          left: x - size,
          top: y - size,
          child: Icon(Icons.emoji_events, color: Colors.amber, size: 2 * size),
        );
      }

      return Positioned(
        left: x - size,
        top: y - size,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SingleTaskScreen(task: node)
                ),
            );
          },
          child: Container(
            width: size * 2,
            height: size * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: node.color,
            ),
            alignment: Alignment.center,
            child: Text(
              node.text,
              style: TextStyle(
                color: ColorConstants.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: FontConstants.standardFontSize,
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> _buildIcons(List<TaskNode> nodes, double width, double size) {
    return List.generate(nodes.length, (i) {
      if (!nodes[i].flag) return SizedBox.shrink();
      final double x = width / 2 + (i % 2 == 0 ? - circleOffset : circleOffset);
      final double y = spacing * (i + 1);
      return Positioned(
        left: x + size - (size / 4),
        top: y - size,
        child: Transform.rotate(
          angle: pi / 4,
          child: Icon(Icons.flag, color: nodes[i].color, size: size),
        ),
      );
    });
  }
}

class TaskNode {
  final String text;
  final Color color;
  final bool flag;
  final bool isTrophy;
  final String title;
  final String description;
  final String category;
  final int difficulty;

  TaskNode({
    required this.text,
    required this.color,
    this.flag = false,
    this.isTrophy = false,
    this.title = "",
    this.description = "",
    this.category = "",
    this.difficulty = 3,
  });
}

class TaskPathPainter extends CustomPainter {
  final List<TaskNode> nodes;
  final double width;
  final double spacing;
  final int dashLength;
  final int gapLength;
  final double circleOffset;

  TaskPathPainter({
    required this.nodes,
    required this.width,
    required this.spacing,
    this.dashLength = 10,
    this.gapLength = 5,
    required this.circleOffset
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorConstants.whiteColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final positions = List.generate(nodes.length, (i) => Offset(
        width / 2 + (i % 2 == 0 ? -circleOffset : circleOffset),
        spacing * (i + 1)
    ));
    for (int i = 0; i < positions.length - 1; i++) {
      _drawDashedLine(canvas, paint, positions[i], positions[i + 1]);
    }
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    double dx = end.dx - start.dx;
    double dy = end.dy - start.dy;
    double distance = sqrt(dx * dx + dy * dy);
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

