import 'package:flutter/material.dart';

class CanvasScreen extends StatelessWidget {
  const CanvasScreen(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const  Expanded(
          child: DrawingCanvas(), // Canvas widget'ınız burada
        ),
      ],
    );
  }
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() {
    return _DrawingCanvasState();
  }
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  List<Offset?> points = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          points.add(renderBox.globalToLocal(details.globalPosition));
        });
      },
      onPanEnd: (details) {
        points.add(null);
      },
      child: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
                'assets/test1.png'), // Resminizi burada gösteriyoruz.
          ),
          CustomPaint(
            painter: CanvasPainter(points),
            size: Size.infinite, // CustomPaint'in tüm alanı kaplamasını sağlar.
          ),
        ],
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset?> points;

  CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}
