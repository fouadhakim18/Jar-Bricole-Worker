// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../main.dart';
import '../../model/booking.dart';
import '../../utils/colors.dart';
import '../../utils/notifs.dart';
import '../../utils/user_data.dart';
import 'map.dart';

// ignore: must_be_immutable
Position? _currentPosition;

class UpcomingBookingContainer extends StatefulWidget {
  Booking booking;
  String? userToken;
  String userName;
  String userLocation;
  String userPhone;
  double latitude;
  double longitude;
  BuildContext ctx;
  UpcomingBookingContainer({
    Key? key,
    required this.booking,
    required this.userToken,
    required this.userName,
    required this.userLocation,
    required this.userPhone,
    required this.latitude,
    required this.longitude,
    required this.ctx,
  }) : super(key: key);

  @override
  State<UpcomingBookingContainer> createState() =>
      _UpcomingBookingContainerState();
}

class _UpcomingBookingContainerState extends State<UpcomingBookingContainer> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _currentPosition = position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            print("client");
            print(widget.latitude);
            print(widget.longitude);
            print("latiid==========");
            print(_currentPosition!.latitude);
            Get.to(
              () => Mapp(
                userLatitude: widget.latitude,
                userLongitude: widget.longitude,
                workerLatitude: _currentPosition!.latitude,
                workerLongitude: _currentPosition!.longitude,
              ),
            );
          },
          child: AnimatedSize(
            alignment: Alignment.topCenter,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 4, spreadRadius: 2)
                  ]),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListTile(
                      title: Text(
                        widget.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(widget.userLocation),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.black54,
                              size: 22.sp,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              widget.booking.date,
                              style: TextStyle(fontSize: 13.sp),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              color: Colors.black54,
                              size: 22.sp,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(widget.booking.time,
                                style: TextStyle(fontSize: 13.sp)),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: widget.booking.status == "Assigned"
                                      ? AppColors.red
                                      : Colors.green,
                                  shape: BoxShape.circle),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            widget.booking.status == "Assigned"
                                ? Text(
                                    "43".tr,
                                    style: TextStyle(
                                        color: AppColors.red, fontSize: 13.sp),
                                  )
                                : widget.booking.status == "Pending"
                                    ? Text(
                                        "44".tr,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 13.sp),
                                      )
                                    : Text(
                                        "47".tr,
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 13.sp),
                                      )
                          ],
                        )
                      ],
                    ),
                    widget.booking.status == "Assigned"
                        ? const SizedBox()
                        : const SizedBox(
                            height: 20,
                          ),
                    widget.booking.status == "Assigned"
                        ? const SizedBox()
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _cancel(widget.booking.id, widget.ctx);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                          color: AppColors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          "89".tr,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      widget.booking.status == "Pending"
                                          ? _approve(widget.booking.id)
                                          : widget.booking.status == "Confirmed"
                                              ? _complete(
                                                  widget.booking.id, widget.ctx)
                                              : _delete(widget.booking.id,
                                                  widget.ctx);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                          color:
                                              widget.booking.status == "Pending"
                                                  ? Colors.green
                                                  : widget.booking.status ==
                                                          "Confirmed"
                                                      ? AppColors.mainBlue
                                                      : AppColors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                        child: Text(
                                          widget.booking.status == "Pending"
                                              ? "88".tr
                                              : widget.booking.status ==
                                                      "Confirmed"
                                                  ? "90".tr
                                                  : "91".tr,
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                    const SizedBox(
                      height: 10,
                    ),
                    isExpanded
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 9.0, right: 9, top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "23".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainBlue),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(widget.booking.moreDetails == ""
                                    ? "48".tr
                                    : widget.booking.moreDetails),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "24".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainBlue),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(widget.booking.locationUser == ""
                                    ? "48".tr
                                    : widget.booking.locationUser),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "25".tr,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainBlue),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(widget.userPhone),
                                const SizedBox(
                                  height: 7,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: SizedBox(
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Icon(
                                isExpanded
                                    ? Icons.arrow_upward_sharp
                                    : Icons.arrow_downward_sharp,
                                size: 25,
                                color: AppColors.mainBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _cancel(String? id, BuildContext ctx) async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      Navigator.pop(ctx, true);
      showTopSnackBar(
          Overlay.of(ctx),
          const CustomSnackBar.error(
            message: 'Booking canceled',
          ));
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(id)
          .update({'status': 'Canceled'});
      final userData = await UserData().getUserData();

      sendNotif("Booking Canceled",
          '${userData.get("Name")} canceled your booking', widget.userToken!);
    } catch (e) {
      Navigator.pop(ctx, true);

      showTopSnackBar(
          Overlay.of(ctx),
          const CustomSnackBar.error(
            message: 'Booking non canceled',
          ));
    }
  }

  Future<void> _approve(String? id) async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(id)
          .update({'status': 'Confirmed'});
      Navigator.pop(context, true);

      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
            message: 'Booking Confirmed',
          ));
      final userData = await UserData().getUserData();

      sendNotif("Booking Approved",
          '${userData.get("Name")} approved your booking', widget.userToken!);
    } catch (e) {
      Navigator.pop(context, true);

      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Booking non confirmed',
          ));
    }
  }

  Future<void> _complete(String? id, BuildContext ctx) async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(ctx, true);

      showTopSnackBar(
          Overlay.of(ctx),
          const CustomSnackBar.success(
            message: 'Booking Completed',
          ));
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(id)
          .update({'status': 'Completed'});
      final userData = await UserData().getUserData();

      sendNotif("Job Completed", '${userData.get("Name")} completed the job',
          widget.userToken!);
    } catch (e) {
      Navigator.pop(ctx, true);

      showTopSnackBar(
          Overlay.of(ctx),
          const CustomSnackBar.error(
            message: 'Booking non comlpeted',
          ));
    }
  }

  Future<void> _delete(String? id, BuildContext ctx) async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.pop(ctx, true);
      showTopSnackBar(
          Overlay.of(ctx),
          const CustomSnackBar.error(
            message: 'Booking deleted',
          ));
      await FirebaseFirestore.instance.collection("bookings").doc(id).delete();
    } catch (e) {
      print(e);
      // Navigator.pop(context, true);

      showTopSnackBar(
          Overlay.of(ctx),
          const CustomSnackBar.error(
            message: 'Booking non deleted',
          ));
    }
  }
}
