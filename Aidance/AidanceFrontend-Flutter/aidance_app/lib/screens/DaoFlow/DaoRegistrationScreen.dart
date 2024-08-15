import 'package:aidance_app/RolesScreen.dart';
import 'package:aidance_app/controllers/AuthControllerDao.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:aidance_app/controllers/ApiController/get_addr_controller.dart';

class DaoRegisterationScreen extends StatefulWidget {
  @override
  _DaoRegisterationScreenState createState() => _DaoRegisterationScreenState();
}

class _DaoRegisterationScreenState extends State<DaoRegisterationScreen> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController signupemail = TextEditingController();
  TextEditingController signuppass = TextEditingController();
  TextEditingController username = TextEditingController();
  // TextEditingController ngono = TextEditingController();
  TextEditingController phone = TextEditingController();
  final _controller = Get.put(DaoAuthController());
  final address_controller = Get.put(GetAddressController());

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      address_controller.getAddressApi();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myColors.theme_turquoise,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Get.to(() => RolesScreen()),
        ),
      ),
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300.h,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.jpg"),
                        fit: BoxFit.fill)),
                child: Container(
                  padding: const EdgeInsets.only(top: 90, left: 20),
                  color: myColors.theme_turquoise.withOpacity(.85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: "Welcome to",
                            style: const TextStyle(
                              fontSize: 25,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    isSignupScreen ? " AIDANCE," : " AIDANCE,",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        isSignupScreen
                            ? "Signup to Continue"
                            : "Login to Continue",
                        style: const TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            buildBottomHalfContainer(true),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 700),
              curve: Curves.bounceInOut,
              top: isSignupScreen ? 230.h : 260.h,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.bounceInOut,
                height: isSignupScreen ? 480.h : 270.h,
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignupScreen
                                          ? myColors.theme_turquoise
                                          : myColors.HeadingColor),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: myColors.theme_turquoise,
                                  )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "SIGNUP",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? myColors.theme_turquoise
                                          : myColors.HeadingColor),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: myColors.theme_turquoise,
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                      if (isSignupScreen) buildSignupSection(),
                      if (!isSignupScreen) buildSigninSection()
                    ],
                  ),
                ),
              ),
            ),
            buildBottomHalfContainer(false),
            Positioned(
              top: MediaQuery.of(context).size.height - 100,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  Text(isSignupScreen ? "Or Signup with" : "Or Signin with"),
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildTextButton(
                            Icons.facebook, "Facebook", Colors.blue),
                        buildTextButton(
                            Icons.mail_outline, "Google", Colors.orange),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          buildTextField(
            Icons.mail_outline,
            "info@demouri.com",
            false,
            true,
            email,
            (val) {
              if (!GetUtils.isEmail(val ?? ''))
                return 'Please enter a valid email address';
              return null;
            },
          ),
          buildTextField(
            Icons.lock_outline,
            "**********",
            true,
            false,
            password,
            (val) {
              if (val == null || val.length < 6)
                return 'Please enter a valid password';
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Row(
              //   children: [
              //     Checkbox(
              //       value: isRememberMe,
              //       activeColor: myColors.theme_turquoise,
              //       checkColor: myColors.whiteColor,
              //       onChanged: (value) {
              //         setState(() {
              //           isRememberMe = value!;
              //         });
              //       },
              //     ),
              //     const Text("Remember me",
              //         style:
              //             TextStyle(fontSize: 12, color: myColors.HeadingColor))
              //   ],
              // ),
            ],
          )
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          buildTextField(
            Icons.account_box,
            "User Name",
            false,
            false,
            username,
            (val) {
              if (val == null || val.isEmpty) return 'Please enter a username';
              return null;
            },
          ),
          // buildTextField(
          //   Icons.numbers,
          //   "NGO Ref. No",
          //   false,
          //   true,
          //   ngono,
          //   (val) {
          //     if (val == null || val.isEmpty)
          //       return 'Please enter a valid NGO Ref. No';
          //   },
          // ),
          buildTextField(
            Icons.email,
            "Email",
            false,
            true,
            signupemail,
            (val) {
              if (!GetUtils.isEmail(val ?? ''))
                return 'Please enter a valid email';
              return null;
            },
          ),
          buildTextField(
            Icons.lock_outline,
            "Password",
            true,
            false,
            signuppass,
            (val) {
              if (val == null || val.length < 6)
                return 'Minimum 6 characters required';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail,
      [TextEditingController? controller,
      String? Function(String?)? validator]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: myColors.theme_turquoise),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: myColors.themeGreyColor),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: myColors.themeGreyColor),
            borderRadius: BorderRadius.circular(10.r),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: myColors.HeadingColor,
          ),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(width: 1, color: Colors.grey),
        minimumSize: const Size(145, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: backgroundColor,
      ),
      child: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 5), Text(title)],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 550.h : 430.h,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              if (showShadow)
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10)
            ],
          ),
          child: !showShadow
              ? GestureDetector(
                  onTap: () {
                    if (isSignupScreen) {
                      _controller.createUser(
                          signupemail.text,
                          signuppass.text,
                          username.text,
                          address_controller.addressList.value.address
                              .toString());
                      // Get.offAllNamed(AppRoutes.);
                    } else {
                      _controller.login(
                          email.text,
                          password.text,
                          address_controller.addressList.value.address
                              .toString());

                      // Get.offAllNamed(AppRoutes.bottomNavScreenEndUser);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          myColors.theme_turquoise,
                          Colors.blueAccent
                        ]),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(.3),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1))
                        ]),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Center(),
        ),
      ),
    );
  }
}
