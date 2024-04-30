import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:servili_employee/pages/ratings/ratings.dart';

import '../../utils/colors.dart';
import '../bookings/schedule.dart';
import '../profile/settings.dart';

Position? _currentPosition;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreen = 0;
  final fbm = FirebaseMessaging.instance;

  Future<void> updateToken(String? token) async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(currentUserUid)
          .update({"EmployeeToken": token});
      print("User token updated successfully!");
    } catch (e) {
      print("Error updating user token: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fbm.getToken().then((token) {
      print("================");
      updateToken(token);
      print(token);
      print("================");

      FirebaseMessaging.onMessage.listen((event) {
        print(event.notification!.title);
      });
    });

    _getLocation();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
      });
      await storeUserLocation(FirebaseAuth.instance.currentUser!.uid,
          position.latitude, position.longitude);
    }
  }

  Future<void> storeUserLocation(
      String userId, double latitude, double longitude) async {
    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(userId)
          .update({'latitude': latitude, 'longitude': longitude});
      print('User location stored in Firestore.');
    } catch (e) {
      print('Error storing user location: $e');
    }
  }

  final screens = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // if we add background image it extends under bottom nav bar
      // appBar: AppBar(),
      body: getSelectedWidget(index: currentScreen),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: AppColors.mainBlue,
        selectedIndex: currentScreen,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => currentScreen = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(
              Icons.calendar_month_rounded,
              size: 30,
            ),
            title: Text("37".tr),
            activeColor: Colors.white,
            inactiveColor: Colors.grey[400],
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.star_rate_rounded,
              size: 30,
            ),
            title: Text("36".tr),
            activeColor: Colors.white,
            inactiveColor: Colors.grey[400],
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(
              Icons.person_2_rounded,
              size: 30,
            ),
            title: Text(
              "35".tr,
            ),
            activeColor: Colors.white,
            inactiveColor: Colors.grey[400],
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    switch (index) {
      case 0:
        return const ScheduleScreen();
      case 1:
        return const RatingsScreen();
      case 2:
        return const ProfileSettings();
      default:
        return Container();
    }
  }
}
