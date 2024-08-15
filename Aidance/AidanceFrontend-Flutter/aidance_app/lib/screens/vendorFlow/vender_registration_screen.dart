import 'dart:developer';

import 'package:aidance_app/controllers/ApiController/get_addr_controller.dart';
import 'package:aidance_app/controllers/AuthControllerBeneficiary.dart';
import 'package:aidance_app/controllers/AuthControllerVendor.dart';
import 'package:aidance_app/controllers/BeneficiaryControllers/SignupControllerBeneficiary/SignupControllerBeneficiary.dart';
import 'package:aidance_app/controllers/EndUserModelController.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterationScreenVendor extends StatefulWidget {
  @override
  _RegisterationScreenVendorState createState() =>
      _RegisterationScreenVendorState();
}

class _RegisterationScreenVendorState extends State<RegisterationScreenVendor> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;

  TextEditingController signuppass = TextEditingController();

  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ngoNumberController = TextEditingController();
  TextEditingController benificiaryCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController campaignIdController = TextEditingController();

  final _controller = Get.put(AuthControlleVendor());
  final formKey = GlobalKey<FormState>();
  final SignupControllerEnduser signupController =
      Get.put(SignupControllerEnduser());

  final EndUserModelController endUserModelController =
      Get.put(EndUserModelController());

  final address_controller = Get.put(GetAddressController());

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      log(currentUser.toString());
      address_controller.getAddressApi();
    });
    super.initState();
  }
  // final RequestController requestController = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // Trick to add the shadow for the submit button
            buildBottomHalfContainer(true),
            //Main Contianer for Login and Signup
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
            // Trick to add the submit button
            buildBottomHalfContainer(false),
            Positioned(
              top: 40.h,
              left: 20,
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24.sp,
                  )),
            ),
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
            emailController,
            (val) {
              if (val!.isValidEmail)
                return 'Please enter a valid email address';
              return null;
            },
          ),
          buildTextField(
            Icons.lock_outline,
            "**********",
            true,
            false,
            signuppass,
            (val) {
              if (val!.isValidPassword) return 'Please enter a valid password';
              return null;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   children: [
              //     Checkbox(
              //       value: isRememberMe,
              //       activeColor: myColors.theme_turquoise,
              //       checkColor: myColors.whiteColor,
              //       onChanged: (value) {
              //         setState(() {
              //           isRememberMe = !isRememberMe;
              //         });
              //       },
              //     ),
              //     // const Text("Remember me",
              //     //     style:
              //     //         TextStyle(fontSize: 12, color: myColors.HeadingColor))
              //   ],
              // ),

              TextButton(
                onPressed: () {},
                child: Text("Forgot Password?",
                    style: TextStyle(
                        fontSize: 12.sp, color: myColors.HeadingColor)),
              )
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
            "Username",
            false,
            false,
            usernameController,
            (val) {
              if (val!.isValidName) return 'Please enter a valid phone number';
              return null;
            },
          ),
          buildTextField(
            Icons.email,
            "Email",
            false,
            true,
            emailController,
            (String? value) {
              if (value != null) {
                return !GetUtils.isEmail(value)
                    ? "Please Enter valid email"
                    : null;
              }
              return "Email is required";
            },
          ),
          buildTextField(
            Icons.lock_outline,
            "Password",
            true,
            false,
            signuppass,
            (String? value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Password is required!";
                }
                return value.length < 8 ? "Minimum 6 character required" : null;
              }
              return "Password is required!";
            },
          ),
          buildTextField(
            Icons.lock_outline,
            "Confirm Password",
            true,
            false,
            confirmPasswordController,
            (String? value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Password is required!";
                }
                return value.length < 8 ? "Minimum 6 character required" : null;
              }
              return "Password is required!";
            },
          ),

          // buildTextField(Icons.lock_outline, "Confirm Password", true, false),

          Container(
            padding: EdgeInsets.only(left: 10.h),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.h),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By going further you agree to our ",
                  style: TextStyle(
                      color: myColors.themeGreyColor, fontSize: 12.sp),
                  children: const [
                    TextSpan(
                      //recognizer: ,
                      text: "term & conditions",
                      style: TextStyle(color: myColors.theme_turquoise),
                    ),
                  ]),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: isSignupScreen ? 630 : 450,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90.h,
          width: 90.w,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              ? GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (isSignupScreen) {
                      _controller.createUser(
                          usernameController.text,
                          emailController.text,
                          signuppass.text,
                          confirmPasswordController.text,
                          address_controller.addressList.value.address
                              .toString(),
                          context);
                      // Get.offAllNamed(AppRoutes.bottomNavScreenEndUser);
                    } else {
                      _controller.login(emailController.text, signuppass.text);

                      // Get.offAllNamed(AppRoutes.bottomNavScreenEndUser);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: myColors.theme_turquoise,
                        // gradient: LinearGradient(
                        //     colors: [Colors.orange[200], Colors.red[400]],
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight),
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

  Widget buildTextField(
      IconData icon,
      String hintText,
      bool isPassword,
      bool isEmail,
      TextEditingController? controller,
      String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        cursorColor: myColors.theme_turquoise,
        style: TextStyle(
          // height: 1.h,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
          filled: true,
          fillColor: const Color(0x379E9E9E),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(4.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: myColors.theme_turquoise,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(4.r),
          ),
          hintText: hintText,
          prefixIcon: Icon(
            icon,
            color: Colors.grey[500],
          ),
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
