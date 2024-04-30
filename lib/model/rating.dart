// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String? id;
  String userName;
  String employeeId;
  String ratingDetails;
  double ratingValue;

  Rating({
    this.id,
    required this.userName,
    required this.employeeId,
    required this.ratingDetails,
    required this.ratingValue,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'employeeId': employeeId,
      'ratingDetails': ratingDetails,
      'ratingValue': ratingValue,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      id: map['id'],
      userName: map['userName'],
      employeeId: map['employeeId'],
      ratingDetails: map['ratingDetails'],
      ratingValue: map['ratingValue'],
    );
  }

  factory Rating.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Rating(
      id: data['id'],
      userName: data['userName'],
      employeeId: data['employeeId'],
      ratingDetails: data['ratingDetails'],
      ratingValue: data['ratingValue'],
    );
  }
}
