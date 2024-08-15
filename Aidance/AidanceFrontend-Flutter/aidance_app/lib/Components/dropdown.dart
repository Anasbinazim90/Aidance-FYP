import 'package:aidance_app/utils/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropdownWidget extends StatefulWidget {
  final double? heightt;
  final double? widthh;
  final String hint;
  final List<String> items;

  const DropdownWidget(
      {super.key,
      this.heightt,
      this.widthh,
      required this.hint,
      required this.items});

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.email),
        filled: true,
        fillColor: const Color(0x379E9E9E),

        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16.h),
        contentPadding: EdgeInsets.only(bottom: 15.h, right: 10.w),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: myColors.theme_turquoise,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: myColors.theme_turquoise,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: const BorderSide(
        //       color: Colors.black,
        //     ),
        //     borderRadius: BorderRadius.all(Radius.circular(20.r)),
        //   ),
      ),
      hint: Text(
        widget.hint,
        style: TextStyle(fontSize: 16.h, color: Colors.grey[500]),
      ),
      items: widget.items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(fontSize: 16.h, color: Colors.grey[500]),
                ),
              ))
          .toList(),
      validator: (value) {
        return null;
      },
      onChanged: (value) {
        value = widget.items.toString();
      },
      onSaved: (items) {
        items = widget.items.toString();
      },
      buttonStyleData: ButtonStyleData(
        height: widget.heightt,
        width: widget.widthh,
        // padding: const EdgeInsets.only(right: 0)/,
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.blueGrey,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
      menuItemStyleData: MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
      ),
    );
  }
}
