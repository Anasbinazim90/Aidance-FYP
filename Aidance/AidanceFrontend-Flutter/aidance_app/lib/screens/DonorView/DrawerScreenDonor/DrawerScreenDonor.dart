import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/DonorViewController/HomeControllerDonor/HomeControllerDonor.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);

  HomeControllerDonor homeController = Get.put(HomeControllerDonor());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerDonor>(
      init: homeController,
      assignId: true,
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                controller.hideDrawer();
              },
              icon: const Icon(Icons.clear, color: Colors.black),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text("Hello!", style: MyTextStyles.HeadingStyle()),
                Text("Anas Bin Azim"),
                SizedBox(height: 40.h),
                ListTile(
                  onTap: () {
                    // Get.toNamed(AppRoutes.viewAll, arguments: ['My Library']);
                  },
                  horizontalTitleGap: 10.w,
                  leading: const Icon(
                    CupertinoIcons.book,
                    color: myColors.HeadingColor,
                  ),
                  title: Text(
                    "Bookmarks",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                ListTile(
                  onTap: () {
                    // Get.toNamed(AppRoutes.aboutUs);
                  },
                  horizontalTitleGap: 10.w,
                  leading: const Icon(
                    Icons.info_outline,
                    color: myColors.HeadingColor,
                  ),
                  title: Text(
                    "About Us",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                ListTile(
                  onTap: () {
                    // Get.toNamed(AppRoutes.privacyPolicy);
                  },
                  horizontalTitleGap: 10.w,
                  leading: const Icon(
                    Icons.security,
                    color: myColors.HeadingColor,
                  ),
                  title: Text(
                    "Privacy Policy",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                ListTile(
                  onTap: () {
                    // Get.toNamed(AppRoutes.contactUsScreen);
                  },
                  horizontalTitleGap: 10.w,
                  leading: const Icon(
                    Icons.phone,
                    color: myColors.HeadingColor,
                  ),
                  title: Text(
                    "Contact Us",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                ),
                Expanded(child: SizedBox()),
                ListTile(
                  onTap: () {
                    Get.offAll(RolesScreen());
                  },
                  horizontalTitleGap: 10.w,
                  leading: const Icon(
                    Icons.logout,
                    color: myColors.HeadingColor,
                  ),
                  title: Text(
                    "Logout",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                50.h.verticalSpace
              ],
            ),
          ),
        );
      },
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  Widget icon;
  final Function()? press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      onTap: press,
      horizontalTitleGap: 0.0,
      visualDensity: const VisualDensity(vertical: 0, horizontal: 0),
      leading: icon,
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: myColors.HeadingColor, fontSize: 16.sp),
      ),
    );
  }
}
