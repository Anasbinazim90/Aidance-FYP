import 'package:aidance_app/controllers/RoleScreenController.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/screens/BeneficiaryFlow/RegisterationScreenBeneficiary/RegisterationScreenBeneficiary.dart';
import 'package:aidance_app/screens/DaoFlow/DaoBottomBar.dart';
import 'package:aidance_app/screens/DaoFlow/DaoRegistrationScreen.dart';
import 'package:aidance_app/screens/NgoFlow/BottomNavScreenNgo/BottomNavScreenNgo.dart';
import 'package:aidance_app/screens/NgoFlow/RegisterationScreenNgo/RegisterationScreenNgo.dart';
import 'package:aidance_app/screens/RegisterationScreens/RegisterationScreen.dart';
import 'package:aidance_app/screens/vendorFlow/vender_registration_screen.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RolesScreen extends StatelessWidget {
  RolesScreen({super.key});

  final List<String> titles = ['Donor', 'NGO', 'Beneficiary', 'DAO', 'Vendor'];

  void navigateToRelatedScreen(int index) {
    // Implement your navigation logic here
    switch (index) {
      case 0:
        Get.to(() => DonorRegisterationScreen());
        break;
      case 1:
        Get.to(() => RegisterationScreenNgo());
        break;
      case 2:
        Get.to(() => RegisterationScreenBeneficiary());
        break;
      case 3:
        Get.to(() => DaoRegisterationScreen());
        break;
      case 4:
        Get.to(() => RegisterationScreenVendor());
        break;
      default:
        break;
    }
  }

  final List<ImageProvider> images = [
    AppImages.donor1,
    AppImages.ngo,
    AppImages.beneficiary,
    AppImages.dao,
    AppImages.donor2,
  ];

  var istap = false;

  final _rolescrController = Get.put(RoleScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          200.h.verticalSpace,
          Text(
            'Who are you ?',
            style: MyTextStyles.HeadingStyle(),
          ),
          Expanded(
              child: GridView.builder(
            itemCount: titles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Obx(
                () => GestureDetector(
                  onTap: () {
                    _rolescrController.selectedIndex.value = index;
                    navigateToRelatedScreen(index);
                  },
                  child: RoleCard(
                    title: titles[index],
                    image: images[index],
                    isSelected: _rolescrController.selectedIndex.value == index,
                  ),
                ),
              );
            },
          ).animate())
        ],
      ),
    ));
  }
}

class RoleCard extends StatelessWidget {
  RoleCard({
    super.key,
    required this.title,
    required this.image,
    required this.isSelected,
  });

  final String title;
  final ImageProvider<Object> image;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 2,
      child: Container(
        // height: 120.h,
        // width: 120.w,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3.r),
            border: Border.all(
                color: isSelected
                    ? myColors.theme_turquoise
                    : myColors.themeGreyColor,
                width: 0.2),
            boxShadow: [
              isSelected
                  ? BoxShadow(
                      color: Palette.theme_turquoise.shade200,
                      blurRadius: 2.0,
                      spreadRadius: 0.5,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  : BoxShadow()
            ]),

        child: Column(
          children: [
            Text(
              title,
              style: MyTextStyles.HeadingStyle().copyWith(fontSize: 18.sp),
            ),
            16.h.verticalSpace,
            Container(
              width: 70,
              height: 70,
              child: Image(
                fit: BoxFit.cover,
                image: image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
