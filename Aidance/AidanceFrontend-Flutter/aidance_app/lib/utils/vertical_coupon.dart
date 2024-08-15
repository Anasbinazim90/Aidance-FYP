import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/palette.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VerticalCouponExample extends StatelessWidget {
  const VerticalCouponExample(
      {Key? key, required this.ngoName, required this.amount, this.onPressed})
      : super(key: key);

  final String ngoName;
  final String amount;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CouponCard(
      height: 300,
      curvePosition: 180,
      curveRadius: 30,
      borderRadius: 10,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Palette.theme_turquoise.shade300, Palette.theme_turquoise],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      firstChild: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ngoName,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            double.parse(amount).toStringAsFixed(4),
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'ETH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      secondChild: Container(
        width: double.maxFinite,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 42),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 40),
            ),
            backgroundColor: WidgetStateProperty.all<Color>(
              Colors.white,
            ),
          ),
          onPressed: onPressed,
          child: const Text(
            'REDEEM',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: myColors.theme_turquoise,
            ),
          ).animate().saturate(
                duration: 400.ms,
              ),
        ).animate().shimmer(
            duration: 900.ms,
            size: 10,
            color: myColors.theme_turquoise.withOpacity(0.5),
            delay: 200.ms),
      ),
    );
  }
}
