import 'package:flutter/material.dart';

void main() async {
  runApp(const DiaryPage2());
}

class DiaryPage2 extends StatelessWidget {
  const DiaryPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Diary2();
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: Center(
        child: Text('This is a new page'),
      ),
    );
  }
}

class Diary2 extends StatefulWidget {
  @override
  _Diary1State createState() =>
      _Diary1State(); // _DiaryPageState에서 _Diary1State로 변경
}

class _Diary1State extends State<Diary2> {
  // DiaryPage1에서 Diary1로 변경
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD74A),
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: double.infinity,
          height: double.infinity,
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
