import 'package:flutter/material.dart';
import 'package:life_secretary/util/util.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.icon,
    required this.callback,
    required this.text,
    this.isRotate = false,
  });

  final IconData icon;
  final Function callback;
  final String text;
  final bool isRotate;

  Widget renderIcon(BuildContext context) {
    if (isRotate) {
      return Transform.rotate(
        angle: 90 * 3.1415927 / 180, // 90도 회전 (라디안 단위)
        child: Icon(
          icon,
          size: getIconSize(context),
          color: Colors.blue[900],
        ),
      );
    }
    return Icon(
      icon,
      size: getIconSize(context),
      color: Colors.blue[900],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => callback(),
      splashColor: Colors.blue.withAlpha(50), // 눌림 효과 색상
      highlightColor: Colors.blue.withAlpha(50), // 강조 색상
      child: Card(
        color: Colors.blue[50], // 배경색 추가
        elevation: 8.0, // 그림자 높이 추가
        shadowColor: Colors.blue[200], // 그림자 색상 추가
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderIcon(context),
              SizedBox(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: getTextSize(context),
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
