import 'package:flutter/material.dart';
import 'dart:math' as math;

class CaterpillarProgressPage extends StatefulWidget {
  @override
  _CaterpillarProgressPageState createState() => _CaterpillarProgressPageState();
}

class _CaterpillarProgressPageState extends State<CaterpillarProgressPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<ProgressData> progressList = [
    ProgressData(icon: Icons.construction, label: 'Construction', progress: 0.85),
    ProgressData(icon: Icons.agriculture, label: 'Agriculture', progress: 0.70),
    ProgressData(icon: Icons.electric_bolt, label: 'Energy', progress: 0.60),
    ProgressData(icon: Icons.landscape, label: 'Mining', progress: 0.90),
    ProgressData(icon: Icons.precision_manufacturing, label: 'Manufacturing', progress: 0.75),
    ProgressData(icon: Icons.eco, label: 'Sustainability', progress: 0.50),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Caterpillar Progress', style: TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemCount: progressList.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return IconProgressWidget(
            icon: progressList[index].icon,
            label: progressList[index].label,
            progress: progressList[index].progress,
            controller: _controller,
          );
        },
      ),
    );
  }
}

class ProgressData {
  final IconData icon;
  final String label;
  final double progress;

  ProgressData({required this.icon, required this.label, required this.progress});
}

class IconProgressWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final double progress;
  final AnimationController controller;

  IconProgressWidget({
    required this.icon,
    required this.label,
    required this.progress,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(100, 100),
                painter: CircleProgressPainter(
                  progress: controller.value * progress,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 40,
                    color: Colors.yellow,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(color: Colors.yellow.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  final double progress;

  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}