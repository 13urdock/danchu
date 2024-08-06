import 'package:flutter/material.dart';

void main() async {
  runApp(const DiaryPage1());
}

class DiaryPage1 extends StatelessWidget {
  const DiaryPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Diary1();
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class Diary1 extends StatefulWidget {
  @override
  _Diary1State createState() =>
      _Diary1State(); // _DiaryPageState에서 _Diary1State로 변경
}

class _Diary1State extends State<Diary1> {
  // DiaryPage1에서 Diary1로 변경
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD74A),
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 12 - 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ),
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
          padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        ),
      ),
    );
  }
}
