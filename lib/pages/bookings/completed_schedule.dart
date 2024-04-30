// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servili_employee/model/users.dart';

import '../../model/booking.dart';
import 'completed_booking_container.dart';

class CompletedSchedule extends StatefulWidget {
  Query<Map<String, dynamic>> bookingRef;
  CompletedSchedule({
    Key? key,
    required this.bookingRef,
  }) : super(key: key);

  @override
  State<CompletedSchedule> createState() => _CompletedScheduleState();
}

class _CompletedScheduleState extends State<CompletedSchedule> {
  Future<UserModel> getDocumentById(String id) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('clients').doc(id).get();
    return UserModel.fromMap(snapshot.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.bookingRef
            .where('status', whereIn: ["Completed"]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Expanded(
                child: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.data!.docs.isEmpty) {
            return const SizedBox();
          }
          final bookings = snapshot.data!.docs
              .map((doc) => Booking.fromSnapshot(doc))
              .toList();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            margin: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return FutureBuilder(
                          future: getDocumentById(booking.userId),
                          builder:
                              (context, AsyncSnapshot<UserModel> snapshot) {
                            if (snapshot.hasData) {
                              UserModel client = snapshot.data!;

                              return CompletedBookingContainer(
                                booking: booking,
                                userName: client.name,
                                userLocation: client.wilaya!,
                                userPhone: client.phone,
                                latitude: client.latitude!,
                                longitude: client.longitude!,
                                ctx: context,
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(70.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                          });
                    }),
              ],
            ),
          );
        });
  }
}
