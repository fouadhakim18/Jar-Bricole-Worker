// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servili_employee/pages/home/home.dart';
import 'package:servili_employee/widgets/button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../utils/colors.dart';
import 'login.dart';

class PendingPage extends StatefulWidget {
  final String? employeeId;
  const PendingPage({
    Key? key,
    required this.employeeId,
  }) : super(key: key);

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('employees')
            .doc(widget.employeeId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var userDocument = snapshot.data;
          if (userDocument!['Status'] == "Pending") {
            // User is not accepted yet, show waiting page

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage("assets/images/Post-rafiki.png")),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "15".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "16".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Button(
                      text: "34".tr,
                      clicked: signOut,
                      color: AppColors.red,
                    ),
                  )
                ],
              ),
            );
          } else if (userDocument['Status'] == "Blocked" ||
              userDocument['Status'] == "Rejected") {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage("assets/images/Post-rafiki.png")),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "17".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "18".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Button(
                      text: "34".tr,
                      clicked: signOut,
                      color: AppColors.red,
                    ),
                  )
                ],
              ),
            );
          } else {
            // User is accepted, navigate to home page
            return const HomeScreen();
          }
        },
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Déconnecté avec succés',
        ),
      );
      Get.to(() => const LogInpage());
    } catch (e) {
      print(e.toString());
    }
  }
}
