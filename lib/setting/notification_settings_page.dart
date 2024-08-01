import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _scheduleNotification = true;
  bool _sound = true;
  bool _vibration = true;
  bool _friendAddNotification = true;
  bool _doNotDisturb = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림설정'),
        backgroundColor: Color(0xFFFFF176),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('일정 알림'),
            value: _scheduleNotification,
            onChanged: (bool value) {
              setState(() {
                _scheduleNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('소리'),
            value: _sound,
            onChanged: (bool value) {
              setState(() {
                _sound = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('진동'),
            value: _vibration,
            onChanged: (bool value) {
              setState(() {
                _vibration = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('친구 추가 푸시 알림'),
            value: _friendAddNotification,
            onChanged: (bool value) {
              setState(() {
                _friendAddNotification = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('방해 금지 모드'),
            value: _doNotDisturb,
            onChanged: (bool value) {
              setState(() {
                _doNotDisturb = value;
              });
            },
          ),
          ListTile(
            title: Text('방해 금지 시간 시작'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 방해 금지 시간 시작 설정
            },
          ),
          ListTile(
            title: Text('방해 금지 시간 끝'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // 방해 금지 시간 끝 설정
            },
          ),
        ],
      ),
    );
  }
}