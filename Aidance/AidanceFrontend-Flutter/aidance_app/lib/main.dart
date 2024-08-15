// ignore_for_file: prefer_const_constructors

import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/DaoControllers/ProposalDetailController.dart';
import 'package:aidance_app/controllers/EndUserModelController.dart';
import 'package:aidance_app/controllers/NgoCampaignModelController.dart';
import 'package:aidance_app/controllers/NgoModelController.dart';
import 'package:aidance_app/firebase_options.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/DaoFlow/DaoBottomBar.dart';
import 'package:aidance_app/screens/DaoFlow/DaoHomeScreen.dart';
import 'package:aidance_app/screens/DaoFlow/CampaignVotingScreen.dart';
import 'package:aidance_app/screens/Example/QRCodeGenerator.dart';
import 'package:aidance_app/screens/Example/Scanner.dart';
import 'package:aidance_app/screens/NgoFlow/RegisterationScreenNgo/RegisterationScreenNgo.dart';
import 'package:aidance_app/screens/RegisterationScreens/RegisterationScreen.dart';
import 'package:aidance_app/screens/SplashScreen.dart';
import 'package:aidance_app/screens/onBoardingScreen/OnBoardingScreen.dart';
import 'package:aidance_app/screens/DaoFlow/NgoVotingScreen.dart';
import 'package:aidance_app/screens/DonationFlow/Complete_transaction/Complete_transaction.dart';
import 'package:aidance_app/screens/DonationFlow/PageView/MainPageViewScreen.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/RegisterationScreenBeneficiary/RegisterationScreenBeneficiary.dart';
import 'package:aidance_app/screens/NgoFlow/CreateCampaignNgo/CreateCampaignNgo.dart';
import 'package:aidance_app/screens/DonationFlow/DonationInfo/DonationInfo.dart';
import 'package:aidance_app/screens/RegisterationScreens/RegisterationScreen.dart';
import 'package:aidance_app/screens/DonorView/BottomNavScreenDonor/BottomNavScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/OnboardingScreen/OnboardingScreen.dart';
import 'package:aidance_app/screens/exapmle_login_screen.dart';
import 'package:aidance_app/screens/upload_img_ipfs.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  Animate.restartOnHotReload = true;
  WidgetsFlutterBinding.ensureInitialized();
  TimerController _timerController = Get.put(TimerController());
  final ngoModelController = Get.put(NgoModelController());
  final endUserModelController = Get.put(EndUserModelController());
  final ngoProposalController = Get.put(NGOProposalController());
  await Firebase.initializeApp();
//   TimerController _timerController = Get.put(TimerController());
//   final ngoModelController = Get.put(NgoModelController());
//   final endUserModelController = Get.put(EndUserModelController());
//   final ngoProposalController = Get.put(NGOProposalController());
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   )
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 892),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Aidance',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Inter',
            useMaterial3: true,
            // primarySwatch: Palette.theme_turquoise,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Palette.theme_turquoise,
              backgroundColor: myColors.light_theme,
              accentColor: myColors.HeadingColor,
            ),
            scaffoldBackgroundColor: Colors.white,
            bottomSheetTheme: BottomSheetThemeData(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
                elevation: 0, backgroundColor: Colors.white, centerTitle: true
                // iconTheme: IconThemeData(color: Colors.black),
                ),
          ),

          // initialRoute: AppRoutes.bottomNavScreen,
          home: SplashScreen(),

          getPages: AppRoutes.pages,
        );
      },
    );
  }
}
