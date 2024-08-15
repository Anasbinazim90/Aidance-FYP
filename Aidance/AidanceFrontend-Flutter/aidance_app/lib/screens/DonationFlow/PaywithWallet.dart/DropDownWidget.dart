import 'package:aidance_app/controllers/DonationFlow_controllers/PayCryptoController/PayCryptoController.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/images.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class DropDownWidget2 extends StatefulWidget {
  const DropDownWidget2({super.key});

  @override
  State<DropDownWidget2> createState() => _DropDownWidget2State();
}

class _DropDownWidget2State extends State<DropDownWidget2> {
  final pay_crypto_controller = Get.put(PayCryptoController());

  String dropdown_value = 'ETH';

  final _items = [
    'ETH',
    'BTC',
    'USDT',
  ];

  var icons = [
    AppImages.Img_Ethereum,
    AppImages.Img_Bitcoin,
    AppImages.Img_usdc,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 120.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: DropdownButton2<String>(
          onMenuStateChange: (isOpen) {
            pay_crypto_controller.isDropDownTapped.value = true;
          },
          value: dropdown_value,
          alignment: Alignment.bottomLeft,
          isExpanded: true,
          underline: Container(),
          dropdownStyleData: DropdownStyleData(
            width: 220.w, elevation: 2, direction: DropdownDirection.left,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            offset: const Offset(0, -15),
            // padding: EdgeInsets.symmetric(horizontal: 0.w),
          ),
          buttonStyleData: ButtonStyleData(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            width: 120.w,
            height: 45.h,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
          ),
          style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'),
          menuItemStyleData: MenuItemStyleData(
              selectedMenuItemBuilder: (context, child) {
                return Container(
                  color: Palette.theme_turquoise[600],
                  child: child,
                );
              },
              overlayColor:
                  MaterialStatePropertyAll(Palette.theme_turquoise[500])),
          iconStyleData: IconStyleData(
            // openMenuIcon: Icon(Icons.face),
            icon: Icon(
              EvaIcons.arrow_down,
              color: pay_crypto_controller.isDropDownTapped.value
                  ? myColors.theme_turquoise
                  : Colors.grey,
            ),
            iconSize: 28.sp,
          ),
          items: _items.map((String item) {
            int index = _items.indexOf(item);
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  SvgPicture.asset(
                    icons[index],
                    width: index == 0 ? 20.w : 20.w,
                    height: index == 0 ? 20.h : 20.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: index == 0 ? 10.w : 6.w,
                  ),
                  Text(item),
                ],
              ),
            );
          }).toList(),
          onChanged: (newvalue) {
            setState(() {
              dropdown_value = newvalue!;
              print(dropdown_value);
            });
          }),
    );
  }
}
