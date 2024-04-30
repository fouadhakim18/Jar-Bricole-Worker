import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dzair_data_usage/dzair.dart';
import 'package:dzair_data_usage/langs.dart';
import 'package:dzair_data_usage/wilaya.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:servili_employee/pages/login/waiting.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../main.dart';
import '../../model/employee.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  String phone;
  SignUpPage({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String dropdownValue = "";
  final _db = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  Dzair dzair = Dzair();
  List<Wilaya?>? wilayas;
  String? selectedWilaya;

  List<String> serviceDisplay = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/services.json');
    final data = await json.decode(response);
    List<String> temp = [];
    for (var i = 0; i < data.length; i++) {
      temp.add(data[i]["name"]);
    }
    setState(() {
      serviceDisplay = temp;
      dropdownValue = serviceDisplay[0];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
    wilayas = dzair.getWilayat();
    selectedWilaya = wilayas![0]!.getWilayaName(Language.FR);
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: BackButton(
        //       color: Colors.black,
        //       onPressed: () => Get.to(() => const LogInpage(),
        //           transition: Transition.fadeIn)),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   title: Text(
        //     "38".tr,
        //     style: TextStyle(
        //         color: Colors.black,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 20.sp),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Expanded(
              child: Column(children: [
                const SizedBox(
                  height: 60,
                ),
                Text(
                  "38".tr,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainBlue),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  width: 180,
                  child: Image(image: AssetImage('assets/images/jar-logo.png')),
                ),
                const SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.mainBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            )),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(children: [
                              const SizedBox(
                                height: 40,
                              ),
                              SizedBox(
                                height: 55,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 16.sp),
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Color(0xff34478C),
                                    ),
                                    hintText: "8".tr,
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: const Color(0xfff5f5f5),
                                    filled: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                // height: 55,
                                child: TextFormField(
                                  style: TextStyle(fontSize: 16.sp),
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Color(0xff34478C),
                                    ),
                                    hintText: "2".tr,
                                    hintStyle: TextStyle(fontSize: 14.sp),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    fillColor: const Color(0xfff5f5f5),
                                    filled: true,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (email) => email != null &&
                                          !EmailValidator.validate(email)
                                      ? "entrer un email valid"
                                      : null,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 53.h,
                                child: DropdownButtonFormField(
                                    value: dropdownValue,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.ellipsis,
                                        color: const Color.fromARGB(
                                            255, 104, 103, 103),
                                        fontFamily: "Montserrat Medium"),
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    items: serviceDisplay.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (String? newvalue) {
                                      setState(() {
                                        dropdownValue = newvalue!;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.build,
                                          color: Color(0xff34478C)),
                                      hintText: 'service',
                                      hintStyle: TextStyle(fontSize: 14.sp),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      fillColor: const Color(0xfff5f5f5),
                                      filled: true,
                                    )),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  width: double.maxFinite,
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedWilaya,
                                    hint: const Text('Select a wilaya'),
                                    items: wilayas!.map((Wilaya? wilaya) {
                                      String? wilayaName =
                                          wilaya!.getWilayaName(Language.FR);
                                      return DropdownMenuItem<String>(
                                        value: wilayaName,
                                        child: Text(wilayaName!),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedWilaya = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Button(
                                  // size: 19.sp,
                                  text: "10".tr,
                                  color: AppColors.secBlue,
                                  clicked: () {
                                    userDataProvider.clearUserData();
                                    signUp();
                                  }),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ));
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    final ap = Provider.of<AuthProvider>(context, listen: false);
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      final employee = EmployeeModel(
          email: emailController.text.trim(),
          name: nameController.text.trim(),
          phone: widget.phone,
          service: dropdownValue,
          wilaya: selectedWilaya ?? "",
          employeeToken: "",
          status: "Pending",
          averageRating: 0,
          isOnline: true);

      await _db
          .collection("employees")
          .doc(ap.uid)
          .set(employee.toJson())
          .then((_) {
        Navigator.pop(context, true);

        showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'You are currently in the pending list',
            ));
        Get.to(
            () => PendingPage(
                  employeeId: FirebaseAuth.instance.currentUser!.uid,
                ),
            transition: Transition.fadeIn);
      }).catchError((e) {
        Navigator.pop(context, true);

        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: e.message!,
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context, true);

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      );
    }
  }
}
