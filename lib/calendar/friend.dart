import 'package:flutter/material.dart';

enum AvatarType { ON, OFF, STORY, MYSTORY }

class ImageAvatar extends StatelessWidget {
  final double width;
  final String url;
  final AvatarType type;
  final void Function()? onTap;

  const ImageAvatar({
    Key? key,
    this.width = 30,
    required this.url,
    required this.type,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      AvatarType.STORY => _storyAvatar(),
      AvatarType.ON => _onImage(),
      AvatarType.OFF => _offImage(),
      AvatarType.MYSTORY => _myStoryAvatar(),
    };
  }

  Widget _storyAvatar() {
    return Container(
      padding: const EdgeInsets.all(3.5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xfffce80a),
            Color(0xfffc3a0a),
            Color(0xffc80afc),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: _basicImage(),
      ),
    );
  }

  Widget _basicImage() {
    return CircleAvatar(
      radius: width / 2,
      backgroundImage: NetworkImage(url),
    );
  }

  Widget _onImage() {
    return _basicImage();
  }

  Widget _offImage() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
      child: _basicImage(),
    );
  }

  Widget _myStoryAvatar() {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          _basicImage(),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(Icons.add_circle, color: Colors.blue, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// 아래는 클래스 외부의 함수들입니다.

Widget _myStoryAvatarItem() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: ImageAvatar(
          width: 60,
          type: AvatarType.MYSTORY,
          url: 'https://example.com/myavatar.jpg',
          onTap: () {
            // 스토리 추가 로직
          },
        ),
      ),
      const Text('내 스토리'),
    ],
  );
}

Widget _storyItem(int index) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: ImageAvatar(
          width: 60,
          type: AvatarType.STORY,
          url: 'https://example.com/avatar$index.jpg',
        ),
      ),
      Text('사용자 $index'),
    ],
  );
}

Widget story() {
  return SliverToBoxAdapter(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _myStoryAvatarItem(),
          ...List.generate(
            10,
            (index) => _storyItem(index),
          ),
        ],
      ),
    ),
  );
}



