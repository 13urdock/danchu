import 'package:flutter/material.dart';
import 'diary_writing.dart';
import 'diary_writingAI.dart';

void main() async {
  runApp(const DiaryApp());
}

class DiaryApp extends StatefulWidget {
  const DiaryApp({super.key});

  @override
  _DiaryAppState createState() => _DiaryAppState();
}

class _DiaryAppState extends State<DiaryApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DiaryPage(),
    );
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: CustomPaint(
                    size: Size(
                        constraints.maxWidth / 3, constraints.maxWidth / 3),
                    painter: CirclePainter(),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD74A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 16,
                        top: 16,
                        child: Text(
                          'AI 요약 \n\n\n\n\n\n\n\n\n 일기',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        top: 44,
                        child: GestureDetector(
                          // 추가됨
                          onTap: () {
                            // 추가됨
                            Navigator.push(
                              // 추가됨
                              context, // 추가됨
                              MaterialPageRoute(
                                  builder: (context) => DiaryPage2()), // 추가됨
                            ); // 추가됨
                          }, // 추가됨
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '내용', // 수정됨
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: -10,
                        child: GestureDetector(
                          // 추가됨
                          onTap: () {
                            // 추가됨
                            Navigator.push(
                              // 추가됨
                              context, // 추가됨
                              MaterialPageRoute(
                                  builder: (context) => DiaryPage1()), // 추가됨
                            ); // 추가됨
                          }, // 추가됨
                          child: Container(
                            height: 270,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                '내용', // 수정됨
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 3),
      size.width / 3,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
