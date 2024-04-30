import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

import 'package:country_picker/country_picker.dart';

// ignore: must_be_immutable
class LogInpage extends StatefulWidget {
  const LogInpage({
    Key? key,
  }) : super(key: key);

  @override
  State<LogInpage> createState() => _LogInpageState();
}

class _LogInpageState extends State<LogInpage> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  Country selectedCountry = Country(
      phoneCode: "213",
      countryCode: "DZ",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Algeria",
      example: "Algeria",
      displayName: "Algeria",
      displayNameNoCountryCode: "Algeria",
      e164Key: "");

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final loginLoading =
        Provider.of<AuthProvider>(context, listen: true).loginLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loginLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.mainBlue),
              )
            : CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 370,
                        child:
                            Image(image: AssetImage('assets/images/login.png')),
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColors.mainBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Center(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Align(
                                    alignment: Get.locale?.languageCode == 'fr'
                                        ? Alignment.topLeft
                                        : Alignment.topRight,
                                    child: Text(
                                      "84".tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  SizedBox(
                                    // height: 50,
                                    child: TextField(
                                        controller: phoneController,
                                        style: TextStyle(fontSize: 15.sp),
                                        decoration: InputDecoration(
                                            suffixIcon: const Icon(
                                              Icons.phone,
                                              color: AppColors.secBlue,
                                            ),
                                            hintText: "9".tr,
                                            hintStyle:
                                                TextStyle(fontSize: 14.sp),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            fillColor: const Color(0xfff5f5f5),
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 12.0),
                                            prefixIcon: InkWell(
                                              onTap: () {
                                                showCountryPicker(
                                                    context: context,
                                                    countryListTheme:
                                                        const CountryListThemeData(
                                                            bottomSheetHeight:
                                                                500),
                                                    onSelect: (value) {
                                                      setState(() {
                                                        selectedCountry = value;
                                                      });
                                                    });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 12),
                                                child: Text(
                                                  "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                                ),
                                              ),
                                            ))),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Button(
                                      text: "5".tr,
                                      color: AppColors.secBlue,
                                      clicked: () {
                                        userDataProvider.clearUserData();
                                        final ap = Provider.of<AuthProvider>(
                                            context,
                                            listen: false);
                                        print(selectedCountry.countryCode);
                                        ap.signInWithPhone(
                                            "+${selectedCountry.phoneCode}${phoneController.text.trim()}");
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ]),
      ),
    );
  }
}
