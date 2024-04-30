import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('employees');

  Future<DocumentSnapshot<Object?>> getUserData() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await _usersCollection.doc(currentUserUid).get();
    return userDoc;
  }
}
