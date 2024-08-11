import 'package:arkitone/ar_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CaterpillarTechnicianPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Industrial background
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: IndustrialBackgroundPainter(),
              ),
              
              // Main content
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.black.withOpacity(0.7),
                      child: Row(
                        children: [
                          Icon(Icons.construction, color: Colors.yellow, size: 40),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CAT TECH VOICE',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                Text(
                                  'Field Report System',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.yellow[300],
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(20),
                        children: [
                          // Quick action buttons
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ActionChip(
                                avatar: Icon(Icons.warning, color: Colors.black),
                                label: Text('Report Issue'),
                                onPressed: () {},
                                backgroundColor: Colors.yellow,
                              ),
                              ActionChip(
                                avatar: Icon(Icons.check_circle, color: Colors.black),
                                label: Text('Maintenance Done'),
                                onPressed: () {},
                                backgroundColor: Colors.yellow,
                              ),
                              ActionChip(
                                avatar: Icon(Icons.inventory, color: Colors.black),
                                label: Text('Parts Request'),
                                onPressed: () {},
                                backgroundColor: Colors.yellow,
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 30),
                          
                          // Recent activity
                          Text(
                            'Recent Activity',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ActivityTile(
                            icon: Icons.build,
                            title: 'Excavator 320 Maintenance',
                            subtitle: 'Completed 2 hours ago',
                          ),
                          ActivityTile(
                            icon: Icons.report_problem,
                            title: 'Hydraulic Leak - Dozer D6',
                            subtitle: 'Reported 1 day ago',
                          ),
                          ActivityTile(
                            icon: Icons.inventory_2,
                            title: 'Air Filter Replacement',
                            subtitle: 'Parts requested 3 days ago',
                          ),
                        ],
                      ),
                    ),
                    
                    // Voice input button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.mic, color: Colors.black),
                        label: Text(
                          'START VOICE REPORT',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: (){

            Navigator.push(
              context,
              MaterialPageRoute(  
                builder: (context) => VoiceForm(),  
              ),
            );
          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class IndustrialBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < 20; i++) {
      double startX = size.width * math.Random().nextDouble();
      double startY = size.height * math.Random().nextDouble();
      double endX = size.width * math.Random().nextDouble();
      double endY = size.height * math.Random().nextDouble();

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Add some "circuit board" like elements
    paint.color = Colors.grey.withOpacity(0.2);
    paint.strokeWidth = 2;
    for (int i = 0; i < 5; i++) {
      double x = size.width * math.Random().nextDouble();
      double y = size.height * math.Random().nextDouble();
      double radius = 20 + math.Random().nextDouble() * 40;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ActivityTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.yellow),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      contentPadding: EdgeInsets.symmetric(vertical: 8),
    );
  }
}