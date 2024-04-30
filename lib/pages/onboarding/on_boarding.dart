import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/colors.dart';
import '../login/login.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final List<Introduction> list = [
    Introduction(
      title: 'étendre',
      subTitle: 'Atteindre de nouveaux clients',
      subTitleTextStyle: TextStyle(fontSize: 19.sp),
      imageUrl: 'assets/images/Electrician-amico.png',
    ),
    Introduction(
      title: 'Escalader',
      subTitle: 'Développez votre travail',
      subTitleTextStyle: TextStyle(fontSize: 19.sp),
      imageUrl: 'assets/images/Electrician-pana.png',
    ),
    Introduction(
      title: 'Et beaucoup plus...',
      titleTextStyle: TextStyle(fontSize: 24.sp),
      subTitle: '',
      imageUrl: 'assets/images/illustration.png',
    ),
  ];

  _storeOnBoardingInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('OnBoarding', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntroScreenOnboarding(
        skipTextStyle: const TextStyle(color: AppColors.mainBlue, fontSize: 18),
        introductionList: list,
        backgroudColor: Colors.white,
        foregroundColor: AppColors.mainBlue,
        onTapSkipButton: () async {
          await _storeOnBoardingInfo();
          // ignore: use_build_context_synchronously
          Get.to(() => const LogInpage(), transition: Transition.fadeIn);
        },
      ),
    ));
  }
}
