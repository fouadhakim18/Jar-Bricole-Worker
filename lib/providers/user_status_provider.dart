import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatusProvider extends ChangeNotifier {
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  void fetchUserStatus() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('employees')
        .doc(userId)
        .get();
    bool status = snapshot["IsOnline"] ?? false;
    _isOnline = status;
    notifyListeners();
  }

  void updateUserStatus(bool status) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('employees')
        .doc(userId)
        .update({'IsOnline': status});
    _isOnline = status;
    notifyListeners();
  }
}