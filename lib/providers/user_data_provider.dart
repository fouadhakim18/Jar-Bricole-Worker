import 'package:flutter/foundation.dart';

import '../utils/user_data.dart';

class ClientData {
  final String name;
  final String email;
  final String phone;
  final String wilaya;
  ClientData(
      {required this.name,
      required this.email,
      required this.phone,
      required this.wilaya});
}

class UserDataProvider extends ChangeNotifier {
  ClientData? userData;

  Future<void> loadUserData() async {
    final uData = await UserData().getUserData();
    userData = ClientData(
        name: uData.get("Name"),
        email: uData.get("Email"),
        phone: uData.get("Phone"),
        wilaya: uData.get("Wilaya"));
    notifyListeners();
  }

  void clearUserData() {
    userData = null;
    notifyListeners();
  }
}
