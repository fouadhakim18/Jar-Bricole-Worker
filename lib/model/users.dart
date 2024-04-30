// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  String name;
  String phone;
  String email;
  String? wilaya;
  String? userToken = "";
  double? latitude;
  double? longitude;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      this.wilaya,
      this.userToken,
      this.latitude,
      this.longitude});

  toJson() {
    return {
      "Name": name,
      "Phone": phone,
      "Email": email,
      "Wilaya": wilaya,
      "UserToken": userToken,
      "Latitude": latitude,
      "Longitude": longitude,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['Name'],
        wilaya: map['Wilaya'],
        phone: map['Phone'],
        email: map['Email'],
        userToken: map['UserToken'],
        latitude: map['latitude'],
        longitude: map['longitude']);
  }
}
