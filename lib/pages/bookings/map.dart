// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:servili_employee/utils/colors.dart';

class Mapp extends StatefulWidget {
  double userLatitude;
  double userLongitude;
  double workerLatitude;
  double workerLongitude;

  Mapp({
    Key? key,
    required this.userLatitude,
    required this.userLongitude,
    required this.workerLatitude,
    required this.workerLongitude,
  }) : super(key: key);

  @override
  State<Mapp> createState() => _MappState();
}

class _MappState extends State<Mapp> {
  @override
  void initState() {
    print("latiid==========");
    print(widget.workerLatitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<LatLng> polylineCoordinates = [
      LatLng(widget.workerLatitude, widget.workerLongitude),
      LatLng(widget.userLatitude, widget.userLongitude),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainBlue,
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.userLatitude, widget.userLongitude),
          zoom: 14.5,
        ),
        polylines: {
          Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates,
              color: AppColors.mainBlue,
              width: 3),
        },
        markers: {
          Marker(
            markerId: const MarkerId('source'),
            position: LatLng(widget.workerLatitude, widget.workerLongitude),
            infoWindow: const InfoWindow(title: 'My Location'),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(widget.userLatitude, widget.userLongitude),
            infoWindow: const InfoWindow(title: 'User Location'),
          ),
        },
      ),
    );
  }
}
