// ignore_for_file: public_member_api_docs, sort_constructors_first

class EmployeeModel {
  String name;
  String phone;
  String email;
  String service;
  String wilaya;
  String? employeeToken = "";
  String status;
  final num? averageRating;
  bool isOnline = true;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.service,
    required this.wilaya,
    this.employeeToken,
    required this.status,
    required this.averageRating,
    required this.isOnline,
  });

  toJson() {
    return {
      "Name": name,
      "Phone": phone,
      "Email": email,
      "Service": service,
      "Wilaya": wilaya,
      "EmployeeToken": employeeToken,
      "Status": status,
      'AverageRating': averageRating,
      'IsOnline': isOnline,
    };
  }
}
