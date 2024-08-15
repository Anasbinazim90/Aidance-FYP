import 'package:aidance_app/screens/DaoFlow/NgoApprovalScreen.dart';
import 'package:aidance_app/screens/DonationFlow/PageView/MainPageViewScreen.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/BottomNavScreenBeneficiary/BottomNavScreenBeneficiary.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/HomeScreenBeneficiary/HomeScreenBeneficiary.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/ProfileScreenBeneficiary/ProfileScreenBeneficiary.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/VoucherScreenBeneficiary/VoucherScreenBeneficiary.dart';
import 'package:aidance_app/screens/NgoFlow/BottomNavScreenNgo/BottomNavScreenNgo.dart';
import 'package:aidance_app/screens/NgoFlow/CreateCampaignNgo/CreateCampaignNgo.dart';
import 'package:aidance_app/screens/NgoFlow/MyCampaignsNgo/MyCampaignsNgo.dart';
import 'package:aidance_app/screens/NgoFlow/RegisterationScreenNgo/RegisterationScreenNgo.dart';
import 'package:aidance_app/screens/RegisterationScreens/RegisterationScreen.dart';
import 'package:aidance_app/screens/DonorView/BookmarkScreenDonor/BookmarkScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/BottomNavScreenDonor/BottomNavScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/CampaignDetailScreenDonor/CampaignDetailScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/DataTableScreenDonor/DataTableScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/HomeScreenDonor/HomeScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/NotificationScreenDonor/NotificationScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/ProfileScreenDonor/ProfileScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/SearchScreenDonor/SearchScreenDonor.dart';
import 'package:aidance_app/screens/DonorView/SettingScreenDonor/SettingScreenDonor.dart';
import 'package:aidance_app/screens/DonationFlow/DonationInfo/DonationInfo.dart';
import 'package:aidance_app/screens/DonationFlow/PaywithWallet.dart/PayWithWalletScreen.dart';
import 'package:aidance_app/screens/vendorFlow/vendor_bottom_nav_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const String splash_screen = '/welcome_screen';
  static const String initial_Route = '/initialRoute';

// User View Routes
  static const String homeScreen = '/homescreen';
  static const String notificationScreen = '/notification';
  static const String profileScreen = '/profile';
  static const String searchScreen = '/search';
  static const String settingScreen = '/setting';
  static const String bottomNavBarScreenDonor = '/bottomNav';
  static const String donationinfo_screen = '/donationinfo_screen';
  static const String pay_with_wallet_screen = '/paywithwallet_screen';
  static const String campaignDetailScreen = '/campaignDetailScreen';
  static const String bookmarkScreen = '/bookmarkScreen';
  static const String dataTableScreen = '/dataTableScreen';
  static const String mainpageviewscreen = '/mainpageviewscreen';
  static const String homeScreenEndUser = '/homeScreenEndUser';
  static const String voucherScreenEndUser = '/voucherScreenEndUser';
  static const String profileScreenEndUser = '/profileScreenEndUser';
  static const String bottomNavScreenBeneficiary =
      '/bottomNavScreenBeneficiary';
  static const String loginScreenEndUser = '/loginScreenEndUser';
  static const String registerationScreen = '/registerationScreen';
  static const String ngoRegisterationScreen = '/ngoRegisterationScreen';
  static const String ngoSignUpScreen = '/ngoSignUpScreen';
  static const String ngoApprovalScreen = '/ngoApprovalScreen';
  static const String bottomNavScreenNgo = '/bottomNavScreenNgo';
  static const String bottomNavBarScreenVendor = '/bottomNavBarScreenVendor';

  //NGO VIEW
  static const String createCompaignScreen = '/createcompaign_screen';
  static const String myCompaignScreen = '/mycompaign_screen';

  static List<GetPage> pages = [
// User View Routes
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: notificationScreen,
      page: () => MyDonationScreen(),
    ),
    GetPage(
      name: profileScreen,
      page: () => ProfileScreenUser(),
    ),
    GetPage(
      name: searchScreen,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: settingScreen,
      page: () => PostCampaignScreen(),
    ),
    GetPage(
      name: bottomNavBarScreenDonor,
      page: () => BottomNavBarScreenDonor(),
    ),
    GetPage(
      name: dataTableScreen,
      page: () => DataTableScreen(
        campaignId: (),
      ),
    ),

    GetPage(
      name: mainpageviewscreen,
      page: () => MainPageViewScreen(),
    ),
    GetPage(
      name: donationinfo_screen,
      page: () => DonationInfoScreen(),
    ),
    GetPage(
      name: pay_with_wallet_screen,
      page: () => PayWithWalletScreen(),
    ),

    // NGO VIEW
    GetPage(
      name: createCompaignScreen,
      page: () => CreateCompaignScreen(),
    ),

    GetPage(name: myCompaignScreen, page: () => MyCompaignScreen()),
    // GetPage(
    //   name: campaignDetailScreen,
    //   page: () => CampaignDetailScreen(),
    // ),
    GetPage(
      name: bookmarkScreen,
      page: () => BookmarkScreen(),
    ),
    GetPage(
      name: homeScreenEndUser,
      page: () => HomeScreenEndUser(),
    ),
    GetPage(
      name: voucherScreenEndUser,
      page: () => VoucherScreen(),
    ),
    GetPage(
      name: profileScreenEndUser,
      page: () => ProfileScreenBeneficiary(),
    ),
    GetPage(
      name: bottomNavScreenBeneficiary,
      page: () => BottomNavScreenBeneficiary(),
    ),
    // GetPage(
    //   name: loginScreenEndUser,
    //   page: () => LoginScreenEndUser(),
    // ),
    // GetPage(
    //   name: registerationScreen,
    //   page: () => DaoRegisterationScreen(),
    // ),
    // GetPage(
    //   name: registerationScreen,
    //   page: () => RegisterationScreenDonor(),
    // ),
    GetPage(
      name: ngoRegisterationScreen,
      page: () => RegisterationScreenNgo(),
    ),
    GetPage(
      name: ngoSignUpScreen,
      page: () => RegisterationScreenNgo(),
    ),
    GetPage(
      name: ngoApprovalScreen,
      page: () => NgoApprovalScreen(),
    ),
    GetPage(
      name: bottomNavScreenNgo,
      page: () => BottomNavScreenNgo(),
    ),
    GetPage(
      name: bottomNavBarScreenVendor,
      page: () => BottomNavScreenVendor(),
    ),
  ];
}
