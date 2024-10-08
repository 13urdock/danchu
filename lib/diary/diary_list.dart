import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/diary/diary_entry.dart';
import '/diary/viewing_diary.dart';
import '../danchu/danchu_list.dart';

class DiaryList extends StatelessWidget {
  final DateTime selectedDate;

  const DiaryList({Key? key, required this.selectedDate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user == null) {
      return Center(child: Text('로그인이 필요합니다.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('danchu')
          .where('date', //한달 일기만 출력
              isGreaterThanOrEqualTo:
                  DateTime(selectedDate.year, selectedDate.month, 1))
          .where('date',
              isLessThan:
                  DateTime(selectedDate.year, selectedDate.month + 1, 1))
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('이번 달에 작성된 일기가 없습니다.'));
        }

        List<DiaryEntry> diaries = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return DiaryEntry(
            content: data['content'],
            date: (data['date'] as Timestamp).toDate(),
            danchu: data['danchu'],
            summary: data['summary'],
          );
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: diaries.length,
          itemBuilder: (context, index) {
            final diary = diaries[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewingDiary(
                          selectedDay: diary.date,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          Danchu().getDanchu(diary.danchu),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('yyyy년 MM월 dd일').format(diary.date),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                diary.content,
                                style: TextStyle(fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
