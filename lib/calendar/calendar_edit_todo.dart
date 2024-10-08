import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:danchu/icon_selector_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../models/todo_item.dart';
import '../models/custom_circle_icon.dart';
import '/src/color.dart';
import 'routine_widgget.dart';

class EditTodo extends StatefulWidget {
  final TodoItem todoItem;

  EditTodo({required this.todoItem});

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Color _selectedColor;
  late DateTime _selectedDate;
  late TimeOfDay _beginTime;
  late TimeOfDay _endTime;
  late bool isAllDay;
  late bool isRoutine;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todoItem.title);
    _descriptionController =
        TextEditingController(text: widget.todoItem.description);
    _selectedColor = widget.todoItem.iconColor;
    _selectedDate = widget.todoItem.date;
    _beginTime = widget.todoItem.beginTime != null
        ? TimeOfDay.fromDateTime(widget.todoItem.beginTime!)
        : TimeOfDay.now();
    _endTime = widget.todoItem.endTime != null
        ? TimeOfDay.fromDateTime(widget.todoItem.endTime!)
        : TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
    isAllDay = widget.todoItem.isAllDay;
    isRoutine = widget.todoItem.isRoutine;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('할 일 수정', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              _buildDatePicker(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              _buildAllDayToggle(screenSize),
              if (!isAllDay) _buildTimeSettings(screenSize, isSmallScreen),
              _buildRoutineToggle(screenSize),
              SizedBox(height: screenSize.height * 0.02),
              if (isRoutine) _buildRoutineCalendar(screenSize),
              _buildDescriptionField(screenSize),
              SizedBox(height: screenSize.height * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _updateTodoItem,
          child: Text('수정하기', style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: AppColors.danchuYellow,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _showIconSelector(),
          child: Container(
            width: screenSize.width * 0.1,
            height: screenSize.width * 0.1,
            padding: EdgeInsets.all(screenSize.width * 0.01),
            child: CustomCircleIcon(
              isSelected: true,
              color: _selectedColor,
              size: screenSize.width * 0.08,
            ),
          ),
        ),
        SizedBox(width: screenSize.width * 0.03),
        Expanded(
          child: TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: '제목',
              labelStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(Size screenSize) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '날짜',
          labelStyle: TextStyle(color: Colors.black),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              style: TextStyle(color: Colors.black),
            ),
            Icon(Icons.calendar_today, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildAllDayToggle(Size screenSize) {
    return Row(
      children: [
        Text('하루종일',
            style: TextStyle(
                fontSize: screenSize.width * 0.04, color: Colors.black)),
        Spacer(),
        Switch(
          value: isAllDay,
          onChanged: (value) {
            setState(() {
              isAllDay = value;
            });
          },
          activeColor: AppColors.danchuYellow,
        ),
      ],
    );
  }

  Widget _buildTimeSettings(Size screenSize, bool isSmallScreen) {
    return isSmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimePicker('시작 시간', _beginTime,
                  (time) => setState(() => _beginTime = time!)),
              SizedBox(height: screenSize.height * 0.02),
              _buildTimePicker('종료 시간', _endTime,
                  (time) => setState(() => _endTime = time!)),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildTimePicker('시작 시간', _beginTime,
                      (time) => setState(() => _beginTime = time!))),
              SizedBox(width: screenSize.width * 0.02),
              Expanded(
                  child: _buildTimePicker('종료 시간', _endTime,
                      (time) => setState(() => _endTime = time!))),
            ],
          );
  }

  Widget _buildTimePicker(
      String label, TimeOfDay time, Function(TimeOfDay?) onChanged) {
    return InkWell(
      onTap: () => _selectTime(context, onChanged),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        child: Text('${time.format(context)}',
            style: TextStyle(color: Colors.black)),
      ),
    );
  }

  Widget _buildRoutineToggle(Size screenSize) {
    return Row(
      children: [
        Icon(Icons.repeat, size: screenSize.width * 0.05, color: Colors.black),
        SizedBox(width: screenSize.width * 0.02),
        Text('루틴 설정',
            style: TextStyle(
                fontSize: screenSize.width * 0.04, color: Colors.black)),
        Spacer(),
        Switch(
          value: isRoutine,
          onChanged: (value) {
            setState(() {
              isRoutine = value;
            });
          },
          activeColor: AppColors.danchuYellow,
        ),
      ],
    );
  }

  Widget _buildRoutineCalendar(Size screenSize) {
    return Container(
      height: screenSize.height * 0.5,
      child: RoutineWidget(
        initialStartDate: _selectedDate,
        initialEndDate: _selectedDate.add(Duration(days: 7)),
        onRoutineSet: (List<DateTime> routineDates) {
          setState(() {
            routineDates = routineDates;
          });
        },
      ),
    );
  }

  Widget _buildDescriptionField(Size screenSize) {
    return TextField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: '설명',
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  void _showIconSelector() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IconSelector(
          onColorSelected: (Color color) {
            setState(() {
              _selectedColor = color;
            });
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future<void> _selectTime(
      BuildContext context, Function(TimeOfDay?) onChanged) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  void _updateTodoItem() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      if (_titleController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty) {
        final updatedTodo = TodoItem(
          id: widget.todoItem.id,
          userId: user.uid,
          date: _selectedDate,
          title: _titleController.text,
          description: _descriptionController.text,
          beginTime: isAllDay
              ? null
              : DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, _beginTime.hour, _beginTime.minute),
          endTime: isAllDay
              ? null
              : DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, _endTime.hour, _endTime.minute),
          isRoutine: isRoutine,
          isAllDay: isAllDay,
          iconColor: _selectedColor,
        );

        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('todos')
              .doc(widget.todoItem.id)
              .update(updatedTodo.toJson());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('할 일이 성공적으로 수정되었습니다.')),
          );
          Navigator.of(context).pop(updatedTodo);
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('수정 중 오류가 발생했습니다: $error')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('제목과 설명을 모두 입력해주세요.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
    }
  }
}
