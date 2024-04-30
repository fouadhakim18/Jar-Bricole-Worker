import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:rating_summary/rating_summary.dart';
import 'package:servili_employee/pages/ratings/rating_card.dart';

import '../../utils/colors.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  String employeeId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const SizedBox(),
        title: Center(child: Text("19".tr)),
        backgroundColor: AppColors.mainBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('ratings')
                .where('employeeId', isEqualTo: employeeId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("error"),
                );
              }
              //  else if (snapshot.data!.docs.isEmpty) {
              //   return const Expanded(
              //     child: Center(
              //       child: Text("Empty"),
              //     ),
              //   );
              // }

              // this part is to calculate ratings summary

              final ratings = snapshot.data!.docs;
              final numRatings = ratings.length;
              final List<int> starCounts = [0, 0, 0, 0, 0];
              double totalRating = 0;
              for (final rating in ratings) {
                final double ratingValue = rating['ratingValue'];
                starCounts[ratingValue.round() - 1]++;
                totalRating += ratingValue;
              }
              double averageRating;
              if (numRatings == 0) {
                averageRating = 0;
              } else {
                averageRating = totalRating / numRatings;
                updateRating(averageRating);
              }

              // **************
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                          color: AppColors.mainBlue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            averageRating.toStringAsFixed(2),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 26),
                          ),
                          const SizedBox(width: 7),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 35,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "${"21".tr} $numRatings ${"22".tr}",
                      style: const TextStyle(
                          fontSize: 15, color: AppColors.mainBlackColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RatingSummary(
                    color: AppColors.mainBlue,
                    showAverage: false,
                    counter: numRatings == 0 ? 1 : numRatings,
                    average: averageRating,
                    counterFiveStars: starCounts[4],
                    counterFourStars: starCounts[3],
                    counterThreeStars: starCounts[2],
                    counterTwoStars: starCounts[1],
                    counterOneStars: starCounts[0],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "20".tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AnimationLimiter(
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot rating =
                            snapshot.data!.docs[numRatings - index - 1];
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            child: ScaleAnimation(
                                duration: const Duration(milliseconds: 800),
                                child: FadeInAnimation(
                                  child: RatingCard(
                                    rating: rating,
                                  ),
                                )));
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> updateRating(num rating) async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(currentUserUid)
          .update({'AverageRating': rating});
    } catch (e) {}
  }
}
