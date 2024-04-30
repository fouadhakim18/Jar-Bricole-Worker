import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:servili_employee/locale/locale_controller.dart';
import 'package:servili_employee/pages/login/login.dart';
import 'package:servili_employee/pages/login/waiting.dart';
import 'package:servili_employee/pages/onboarding/on_boarding.dart';
import 'package:servili_employee/providers/auth_provider.dart';
import 'package:servili_employee/providers/user_data_provider.dart';
import 'package:servili_employee/providers/user_status_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'locale/locale.dart';
import 'utils/utils.dart';

int? isViewed;
SharedPreferences? prefs;
FirebaseMessaging messaging = FirebaseMessaging.instance;
Future main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  isViewed = prefs!.getInt('OnBoarding');
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return ScreenUtilInit(
      designSize: const Size(392.72, 783.27),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserDataProvider()),
            ChangeNotifierProvider(create: (_) => UserStatusProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: GetMaterialApp(
            scaffoldMessengerKey: Utils.messengerKey,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Montserrat Medium'),
            locale: controller.initialLang,
            translations: MyLocale(),
            home: isViewed != 0
                ? const OnBoarding()
                : StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      } else if (snapshot.hasData) {
                        final user = snapshot.data!;
                        return PendingPage(
                          employeeId: user.uid,
                        );
                      } else {
                        return const LogInpage();
                      }
                    }),
          ),
        );
      },
    );
  }
}
