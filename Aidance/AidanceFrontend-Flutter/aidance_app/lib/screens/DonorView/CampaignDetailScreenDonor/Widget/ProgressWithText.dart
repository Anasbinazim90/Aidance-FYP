import 'package:flutter/material.dart';
import 'package:aidance_app/utils/colors.dart'; // Adjust the import path as per your project

class ProgressWithText extends StatefulWidget {
  const ProgressWithText({
    Key? key,
    required this.indicatorValue,
    required this.title,
    required this.value,
  }) : super(key: key);

  final double indicatorValue;
  final String title;
  final double value; // Change type to double

  @override
  _ProgressWithTextState createState() => _ProgressWithTextState();
}

class _ProgressWithTextState extends State<ProgressWithText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _valueAnimation = Tween<double>(begin: 0, end: widget.value)
        .animate(_controller) // Adjust animation with double value
      ..addListener(() {
        setState(() {});
      });

    _indicatorAnimation =
        Tween<double>(begin: 0, end: widget.indicatorValue).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(milliseconds: 200)).then(
        (value) => _controller.forward(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = (MediaQuery.of(context).size.width / 2) - 35;

    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${_valueAnimation.value.toStringAsFixed(2) ?? '0.00'}", // Format double to display with two decimal places
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox.square(
            dimension: w - 30,
            child: RotatedBox(
              quarterTurns: 3,
              child: CircularProgressIndicator(
                color: myColors
                    .theme_turquoise, // Assuming myColors.theme_turquoise is defined
                strokeCap: StrokeCap.round,
                strokeWidth: 10,
                value: _indicatorAnimation.value ?? 0,
                backgroundColor: Colors.grey.withOpacity(.2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    required this.height,
    this.color,
  });

  final Widget child;
  final double height;
  final MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: height,
      decoration: BoxDecoration(
        color: color != null ? null : Colors.white,
        gradient: color == null
            ? null
            : LinearGradient(colors: [color!.shade300, color!.shade500]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 60,
          ),
        ],
      ),
      child: child,
    );
  }
}
