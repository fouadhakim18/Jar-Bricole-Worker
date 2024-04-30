import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class LocaleController extends GetxController {
  Locale initialLang = prefs!.getString("lang") == null
      ? Get.deviceLocale!
      : Locale(prefs!.getString("lang")!);
  void changeLang(String codeLang) async {
    Locale locale = Locale(codeLang);
    prefs!.setString('lang', codeLang);
    Get.updateLocale(locale);
  }
}
