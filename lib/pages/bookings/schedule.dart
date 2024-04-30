import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import 'canceled_schedule.dart';
import 'completed_schedule.dart';
import 'upcoming_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _bookingsRef = FirebaseFirestore.instance
      .collection('bookings')
      .where('employeeId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  late int _buttonIndex = 0;

  @override
  Widget build(BuildContext context) {
    final scheduleWidgets = [
      UpcomingSchedule(bookingRef: _bookingsRef),
      CompletedSchedule(
        bookingRef: _bookingsRef,
      ),
      CanceledSchedule(
        bookingRef: _bookingsRef,
      )
    ];
    return Scaffold(
      appBar: AppBar(
        // leading: SizedBox(),
        backgroundColor: AppColors.mainBlue,
        elevation: 0,
        title: Center(
          child: Text(
            "26".tr,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 6.w),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 0
                              ? AppColors.mainBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "27".tr,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: _buttonIndex == 0
                                  ? Colors.white
                                  : AppColors.textGrey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 1
                              ? AppColors.mainBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "28".tr,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: _buttonIndex == 1
                                  ? Colors.white
                                  : AppColors.textGrey),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 2;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 2
                              ? AppColors.mainBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "29".tr,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: _buttonIndex == 2
                                  ? Colors.white
                                  : AppColors.textGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              scheduleWidgets[_buttonIndex]
            ],
          ),
        ),
      ),
    );
  }
}
