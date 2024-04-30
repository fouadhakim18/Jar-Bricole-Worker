import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../locale/locale_controller.dart';
import '../../providers/user_data_provider.dart';
import '../../utils/colors.dart';
import '../login/login.dart';
import 'profile_edit.dart';
import 'profile_menu.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    return Scaffold(
        appBar: AppBar(
          // leading: GestureDetector(onTap: () {}, child: const SizedBox()),
          backgroundColor: AppColors.mainBlue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ProfileMenu(
              text: "30".tr,
              icon: Icons.person_2_outlined,
              press: () async {
                await Future.delayed(const Duration(milliseconds: 100));
                Get.to(() => Profile(), transition: Transition.fadeIn);
              },
            ),
            ProfileMenu(
              text: "40".tr,
              icon: Icons.language,
              press: () => Get.dialog(LanguageDialog()),
            ),
            ProfileMenu(
                text: "34".tr,
                icon: Icons.logout_outlined,
                color: AppColors.red,
                press: () {
                  userDataProvider.clearUserData();
                  signOut();
                }),
          ],
        )));
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "42".tr,
        ),
      );
      Get.to(() => const LogInpage());
    } catch (e) {
      print(e.toString());
    }
  }
}

class LanguageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.find();
    return AlertDialog(
      title: Text("41".tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.mainBlue, // Set the desired button color here
            ),
            onPressed: () {
              controller.changeLang("fr");
              Get.back();
            },
            child: const Text('Français'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.mainBlue, // Set the desired button color here
            ),
            onPressed: () {
              controller.changeLang("ar");

              Get.back();
            },
            child: const Text('العربية'),
          ),
        ],
      ),
    );
  }
}
