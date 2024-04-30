// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/booking.dart';
import '../../utils/colors.dart';
import 'map.dart';

// this is for both completed and canceled since only booking state color will change
class CompletedBookingContainer extends StatefulWidget {
  Booking booking;
  String userName;
  String userLocation;
  String userPhone;
  double latitude;
  double longitude;
  BuildContext ctx;

  CompletedBookingContainer({
    Key? key,
    required this.booking,
    required this.userName,
    required this.userLocation,
    required this.userPhone,
    required this.latitude,
    required this.longitude,
    required this.ctx,
  }) : super(key: key);

  @override
  State<CompletedBookingContainer> createState() =>
      _CompletedBookingContainerState();
}

class _CompletedBookingContainerState extends State<CompletedBookingContainer> {
  bool isExpanded = false;
  Position? _currentPosition;

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

      setState(() {
        _currentPosition = position;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
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
                        trailing: widget.booking.status == "Canceled"
                            ? const SizedBox()
                            : InkWell(
                                onTap: widget.booking.invoiceUrl == ""
                                    ? null
                                    : () async {
                                        Map<Permission, PermissionStatus>
                                            statuses = await [
                                          Permission.storage,
                                        ].request();

                                        if (statuses[Permission.storage]!
                                            .isGranted) {
                                          var dir = await DownloadsPathProvider
                                              .downloadsDirectory;
                                          if (dir != null) {
                                            String savename =
                                                "facture${DateTime.now().millisecondsSinceEpoch}.pdf";

                                            String savePath =
                                                "${dir.path}/$savename";

                                            try {
                                              await Dio().download(
                                                  widget.booking.invoiceUrl,
                                                  savePath,
                                                  onReceiveProgress:
                                                      (received, total) {});

                                              showTopSnackBar(
                                                  Overlay.of(context),
                                                  const CustomSnackBar.success(
                                                    message:
                                                        'File is saved to download folder',
                                                  ));
                                            } on DioError catch (e) {
                                              print(e.message);
                                            }
                                          }
                                        } else {
                                          showTopSnackBar(
                                              Overlay.of(context),
                                              const CustomSnackBar.error(
                                                message:
                                                    'No permission to read and write',
                                              ));
                                        }
                                      },
                                child: CircleAvatar(
                                  backgroundColor:
                                      widget.booking.invoiceUrl == ""
                                          ? AppColors.grey
                                          : AppColors.mainBlue,
                                  child: const Icon(
                                    Icons.inventory_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
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
                                  color: widget.booking.status == "Completed"
                                      ? Colors.green
                                      : AppColors.red,
                                  shape: BoxShape.circle),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              widget.booking.status == "Completed"
                                  ? "45".tr
                                  : "46".tr,
                              style: TextStyle(
                                  color: widget.booking.status == "Completed"
                                      ? Colors.green
                                      : AppColors.red,
                                  fontSize: 13.sp),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // widget.booking.status == "Canceled"
                    //     ? Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    //         child: Row(
                    //           children: [
                    //             Expanded(
                    //               child: InkWell(
                    //                 onTap: () {
                    //                   _delete(widget.booking.id, widget.ctx);
                    //                 },
                    //                 child: Container(
                    //                   width: 150,
                    //                   padding: const EdgeInsets.symmetric(
                    //                       vertical: 12),
                    //                   decoration: BoxDecoration(
                    //                       color: AppColors.red,
                    //                       borderRadius:
                    //                           BorderRadius.circular(10)),
                    //                   child: Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     children: [
                    //                       const Icon(
                    //                         Icons.delete,
                    //                         color: Colors.white,
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 10,
                    //                       ),
                    //                       Text(
                    //                         "Delete",
                    //                         style: TextStyle(
                    //                             color: Colors.white,
                    //                             fontSize: 15.sp,
                    //                             fontWeight: FontWeight.bold),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ))
                    //     : SizedBox(),
                    // SizedBox(
                    //   height: widget.booking.status == "Canceled" ? 10 : 0,
                    // ),
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
}
