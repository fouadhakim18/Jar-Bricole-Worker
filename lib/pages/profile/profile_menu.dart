import 'package:flutter/material.dart';

import '../../utils/colors.dart';

bool _switch = false;

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.color,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Color? color;
  final VoidCallback? press;

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mainBlue,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        ),
        onPressed: widget.press,
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.color ?? AppColors.mainBlue,
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Text(
              widget.text,
              style: TextStyle(color: widget.color ?? AppColors.textGrey),
            )),
            widget.icon == Icons.dark_mode_outlined
                ? Switch(
                    activeColor: AppColors.mainBlue,
                    value: _switch,
                    onChanged: (value) {
                      setState(() {
                        _switch = value;
                      });
                    },
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: widget.color ?? AppColors.mainBlue,
                  ),
          ],
        ),
      ),
    );
  }
}