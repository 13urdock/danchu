//일기작성페이지

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/src/color.dart';
import 'diary_entry.dart';
import 'stt.dart';
import 'ai_analyzer.dart';

class WritingDiary extends StatefulWidget {
  final DateTime selectedDate;

  const WritingDiary({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _WritingDiaryState createState() => _WritingDiaryState();
}

class _WritingDiaryState extends State<WritingDiary> {
  TextEditingController _diaryController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일'),
        backgroundColor: AppColors.white,
        actions: [
          IconButton( // Speech to Text 아이콘
            icon: Icon(Icons.mic, color: Colors.black),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        STT(selectedDate: widget.selectedDate)),
              );
              if (result != null) {
                setState(() {
                  _diaryController.text = result;
                });
              }
            },
          ),
          TextButton( // 저장 버튼
            onPressed: () {
              _saveDiary(context);
            },
            child: Text('저장', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded( // 일기 추가 아이콘
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'assets/empty.png',
                ),
              ),
            ),
          ),
          Expanded( // 일기 텍스트 박스
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.danchuYellow,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  Expanded(
                    child: _buildContentBox(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox(BuildContext context) {
    //일기 작성
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: TextField(
        controller: _diaryController,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          hintText: '내용을 입력하세요',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  void _saveDiary(BuildContext context) async {
    if (_diaryController.text.isNotEmpty) {
      User? user = _auth.currentUser;
      if (user != null) {
        Map<String, dynamic> sentimentResult =
            await AISentimentAnalyzer.analyzeSentiment(_diaryController.text);

        String selectedDanchu =
            AISentimentAnalyzer.determineEmotionDanchu(sentimentResult);

        String summary = AISentimentAnalyzer.createSummary(sentimentResult);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('danchu')
            .doc(DateFormat('yyyy-MM-dd').format(widget.selectedDate))
            .set({
          'date': widget.selectedDate,
          'content': _diaryController.text,
          'danchu': selectedDanchu,
          'summary': summary,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일기가 저장되었습니다.')),
        );
        Navigator.pop(
            context,
            DiaryEntry(
              content: _diaryController.text,
              date: widget.selectedDate,
              danchu: selectedDanchu,
              summary: summary,
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인이 필요합니다.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('일기 내용을 입력해주세요.')),
      );
    }
  }
}
