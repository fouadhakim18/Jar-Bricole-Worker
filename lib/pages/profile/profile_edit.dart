// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:dzair_data_usage/dzair.dart';
import 'package:dzair_data_usage/langs.dart';
import 'package:dzair_data_usage/wilaya.dart';
import '../../main.dart';
import '../../providers/user_data_provider.dart';
import '../../providers/user_status_provider.dart';
import '../../utils/colors.dart';

String? countryValue;
String? stateValue;
String? cityValue;

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Dzair dzair = Dzair();
  List<Wilaya?>? wilayas;
  ClientData? userData;
  String? currWilaya;
  String? selectedWilaya;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    wilayas = dzair.getWilayat();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    UserStatusProvider userStatusProvider =
        Provider.of<UserStatusProvider>(context);
    userStatusProvider.fetchUserStatus();
    // Check if user data is null, load it if necessary
    if (userDataProvider.userData == null) {
      print("reloaded");
      userDataProvider.loadUserData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("30".tr),
        backgroundColor: AppColors.mainBlue,
      ),
      body: Consumer<UserDataProvider>(
          builder: (context, userDataProviedr, child) {
        if (userDataProvider.userData == null) {
          return Column(
            children: const [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        } else {
          userData = userDataProvider.userData!;
          if (nameController.text.isEmpty) {
            nameController.text = userData!.name;
          }
          if (emailController.text.isEmpty) {
            emailController.text = userData!.email;
          }
          if (phoneController.text.isEmpty) {
            phoneController.text = userData!.phone;
          }
          if (currWilaya == null) {
            currWilaya = userData!.wilaya;
          }
          return SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldWidget(
                          nameController,
                          "8".tr,
                          Icons.person_outlined,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFieldWidget(
                          emailController,
                          "2".tr,
                          Icons.email_outlined,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFieldWidget(
                          phoneController,
                          "9".tr,
                          Icons.phone_outlined,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Text(
                              "31".tr,
                              style: const TextStyle(color: AppColors.mainBlue),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: double.maxFinite,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedWilaya ?? currWilaya,
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
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "32".tr,
                              style: const TextStyle(color: AppColors.mainBlue),
                            ),
                            Switch(
                              activeColor: AppColors.mainBlue,
                              value: userStatusProvider.isOnline,
                              onChanged: (value) {
                                userStatusProvider.updateUserStatus(value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Button("33".tr, () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          await updateUserData();
                          userDataProvider.loadUserData();
                        }, AppColors.mainBlue),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
      }),
    );
  }

  // ignore: non_constant_identifier_names
  TextFieldWidget(
    TextEditingController controller,
    String title,
    IconData iconData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.mainBlue),
        ),
        const SizedBox(
          height: 9,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 15.sp),
            decoration: InputDecoration(
              hintText: title,
              hintStyle:
                  const TextStyle(color: AppColors.textGrey, fontSize: 13),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: AppColors.mainBlue,
                ),
              ),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget Button(String title, Function onPressed, Color color) {
    return MaterialButton(
      height: 50,
      minWidth: MediaQuery.of(context).size.width,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: color,
      onPressed: () => onPressed(),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> updateUserData() async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(currentUserUid)
          .update({
        'Name': nameController.text,
        'Email': emailController.text,
        'Phone': phoneController.text,
        'Wilaya': selectedWilaya ?? currWilaya,
      });
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Mise à jour du votre profil avec succés",
        ),
      );
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.toString(),
        ),
      );
    }
    Navigator.pop(context, true);
  }
}
