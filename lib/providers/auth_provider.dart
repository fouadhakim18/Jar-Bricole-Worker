import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../pages/home/home.dart';
import '../pages/login/otp.dart';
import '../pages/login/sign_up.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;

  String? _uid;
  String get uid => _uid!;

  void signInWithPhone(String phone) async {
    _loginLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.to(() => const HomeScreen());
        },
        verificationFailed: (FirebaseAuthException e) {
          _loginLoading = false;
          notifyListeners();
          Get.snackbar("Error", e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          _loginLoading = false;
          notifyListeners();
          Get.to(() => OTPScreen(
                codeSent: verificationId,
                phone: phone,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
      _loginLoading = false;
      notifyListeners();
    }
  }

  void verifyOtp(String verificationId, String otpCode, String phone) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        _uid = user.uid;
        bool isExistingUser = await checkExistingUser();
        if (isExistingUser) {
          Get.to(const HomeScreen());
        } else {
          Get.to(() => SignUpPage(
                phone: phone,
              ));
        }
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message!);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("employees").doc(_uid).get();
    return snapshot.exists;
  }
}
