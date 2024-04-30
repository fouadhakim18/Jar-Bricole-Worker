import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Color? color;
  final String text;
  final double size;
  Color? textColor;
  VoidCallback clicked; 
  Button(
      {super.key,
      this.color = AppColors.mainBlue,
      this.textColor = Colors.white,
      required this.text,
      this.size = 21,
      required this.clicked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: clicked,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: color,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: size.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
