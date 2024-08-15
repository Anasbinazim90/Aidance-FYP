import 'dart:developer';
import 'dart:io';

import 'package:aidance_app/components/MyTextformfield.dart';
import 'package:aidance_app/components/mainbutton.dart';
import 'package:aidance_app/controllers/ApiController/get_addr_controller.dart';
import 'package:aidance_app/controllers/ApiController/register_ngo_controller.dart';
import 'package:aidance_app/controllers/AuthController.dart';
import 'package:aidance_app/controllers/AuthControllerNgo.dart';
import 'package:aidance_app/controllers/NgoControllers/NgoSignupController.dart';
import 'package:aidance_app/controllers/NgoModelController.dart';
import 'package:aidance_app/models/NgoModel/NgoModel.dart';
import 'package:aidance_app/routes/AppRoutes.dart';
import 'package:aidance_app/utils/colors.dart';
import 'package:aidance_app/utils/myutils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class RegisterationScreenNgo extends StatefulWidget {
  @override
  _RegisterationScreenNgoState createState() => _RegisterationScreenNgoState();
}

class _RegisterationScreenNgoState extends State<RegisterationScreenNgo> {
  bool isSignupScreen = true;
  bool isMale = true;
  bool isRememberMe = false;
  // TextEditingController email = TextEditingController();
  // TextEditingController password = TextEditingController();
  // TextEditingController signupemail = TextEditingController();
  TextEditingController signuppass = TextEditingController();
  // TextEditingController username = TextEditingController();
  // TextEditingController ngono = TextEditingController();
  // TextEditingController phone = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  // final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController missionController = TextEditingController();
  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPass = TextEditingController();

  final _controller = Get.put(AuthControllerNgo());
  final formKey = GlobalKey<FormState>();
  final NgoSignupController controller = Get.put(NgoSignupController());
  final address_controller = Get.put(GetAddressController());
  final register_ngo = Get.put(RegisterNgoController());

  final NgoModelController ngoModelController = Get.put(NgoModelController());

  // firebase current user
  User? user = FirebaseAuth.instance.currentUser;

  void initState() {
    log('initState called');
    log('user ${user?.email}');

    Future.delayed(Duration.zero, () {
      address_controller.getAddressApi();
    });
    super.initState();
  }

  /// File Picker
  List<PlatformFile> selectedFileList = [];

  Future<void> pickFile() async {
    try {
      FilePickerResult? result;

      if (Platform.isIOS) {
        result = await FilePicker.platform.pickFiles(
          allowCompression: true,
          type: FileType.custom,
          allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
        );
      } else {
        result = await FilePicker.platform.pickFiles(
          allowCompression: true,
          type: FileType.custom,
          allowedExtensions: ['pdf', 'png', 'jpeg', 'jpg'],
        );
      }

      if (result != null) {
        for (var element in result.files) {
          int sizeInBytes = element.size;
          double sizeInMb = sizeInBytes / (1024 * 1024);

          if (sizeInMb < 100) {
            if (element.name.contains('.pdf') ||
                element.name.contains('.png') ||
                element.name.contains('.jpeg') ||
                element.name.contains('.jpg')) {
              selectedFileList.add(element);
              setState(() {});
            } else {
              Get.snackbar(
                "Error",
                'Only Audio or Video file can be selected.',
              );
            }
          } else {
            print(sizeInMb);
            Get.snackbar(
              "Error",
              'Selected file is too large',
            );
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadFile(PlatformFile file) async {
    try {
      String fileName = file.name;
      File fileToUpload = File(file.path!);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Upload to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('kyc_docs/$timestamp-$fileName')
          .putFile(fileToUpload);

      if (snapshot.state == TaskState.success) {
        // Get the download URL
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        // Store the download URL in Firestore
        await FirebaseFirestore.instance
            .collection('Ngousers')
            .doc(user!.uid)
            .update({
          'kycdocs': FieldValue.arrayUnion([downloadUrl]),
        });

        // await FirebaseFirestore.instance
        //     .collection('Ngousers')
        //     .doc('documentId')
        //     .update({
        //   'kycdocs': FieldValue.arrayUnion([downloadUrl]),
        // });

        Get.snackbar("Success", "File uploaded successfully.");
      } else {
        Get.snackbar("Error", "File upload failed.");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  // Function to upload file to Firebase Storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: Obx(
          () => Stack(
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
                                  text: isSignupScreen
                                      ? " AIDANCE,"
                                      : " AIDANCE,",
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
              // buildBottomHalfContainer(true),

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
              // buildBottomHalfContainer(false),
              Positioned(
                top: MediaQuery.of(context).size.height - 80.h,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          overlayColor: Colors.white.withOpacity(0.2),
                          backgroundColor: myColors.theme_turquoise,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          )),
                      icon: register_ngo.loading.value
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: SpinKitWaveSpinner(
                                waveColor: myColors.theme_turquoise,
                                trackColor:
                                    myColors.theme_turquoise.withOpacity(0.5),
                                color: myColors.theme_turquoise,
                              ))
                          : const Icon(Icons.login_sharp),
                      label: Text(register_ngo.loading.value
                          ? "Loading..."
                          : isSignupScreen
                              ? "Register"
                              : "Login"),
                      onPressed: (controller.formIsValid.value)
                          ? () async {
                              String name = nameController.text;
                              String email = emailController.text;
                              String password = signuppass.text;
                              String contactNumber = phoneController.text;
                              String address = address_controller
                                  .addressList.value.address
                                  .toString();
                              String registrationNumber =
                                  registrationNumberController.text;
                              String missionAndObjectives =
                                  missionController.text;

                              // Get.offAllNamed(AppRoutes.bottomNavScreenNgo);
                              // print(ngoModelController.Ngos.length);
                              // print(ngoModelController.Ngos[0].name);

                              if (isSignupScreen) {
                                print("emailllllllll" + emailController.text);
                                print(signuppass.text);

                                bool isValid = validateNGOFields(
                                  name: name,
                                  email: email,
                                  password: password,
                                  contactNumber: contactNumber,
                                  registrationNumber: registrationNumber,
                                  missionAndObjectives: missionAndObjectives,
                                );

                                if (!isValid) {
                                  return;
                                }

                                await register_ngo.regesterNgoApi(
                                  registrationNumberController.text,
                                  address_controller.addressList.value.address
                                      .toString(),
                                  context,
                                  emailController.text.trim(),
                                  phoneController.text,
                                  signuppass.text,
                                  nameController.text,
                                  missionController.text,
                                  selectedFileList,
                                );
                              } else {
                                _controller.login(
                                    loginEmail.text, loginPass.text);

                                // Get.offAllNamed(AppRoutes.bottomNavScreenEndUser);
                              }
                            }
                          : () {}),
                ),
              ),

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
      ),
    );
  }

  bool validateNGOFields({
    required String name,
    required String email,
    required String password,
    required String contactNumber,
    required String registrationNumber,
    required String missionAndObjectives,
  }) {
    if (name.isEmpty) {
      Get.snackbar("Error", "name cannot be empty");
      return false;
    }
    if (email.isEmpty) {
      Get.snackbar("Error", "email cannot be empty");
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      Get.snackbar(
          "Error", "passowrd cannot be empty and should be more than 6");
      return false;
    }
    if (contactNumber.isEmpty) {
      Get.snackbar("Error", "contactNumber cannot be empty");
      return false;
    }
    if (registrationNumber.isEmpty) {
      Get.snackbar("Error", "Expiration date cannot be empty");
      return false;
    }
    if (missionAndObjectives.isEmpty) {
      Get.snackbar("Error", "Recipient name cannot be empty");
      return false;
    }

    return true;
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
            loginEmail,
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
            loginPass,
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
              //     const Text("Remember me",
              //         style:
              //             TextStyle(fontSize: 12, color: myColors.HeadingColor))
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
          TextFormField(
            controller: nameController,
            validator: (val) {
              if (val!.isValidName) return 'Please enter a valid phone number';
              return null;
            },
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            // autofocus: true,
            maxLines: null,
            cursorColor: myColors.theme_turquoise,

            style: TextStyle(
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.name,

            decoration: InputDecoration(
              hintText: "Name",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(Icons.account_box, color: Colors.grey[500]),
            ),
          ),
          10.h.verticalSpace,
          // buildTextField(
          //   Icons.email,
          //   "Email",
          //   false,
          //   true,F
          //   emailController,
          //   (String? value) {
          //     if (value != null) {
          //       return !GetUtils.isEmail(value)
          //           ? "Please Enter valid email"
          //           : null;
          //     }
          //     return "Email is required";
          //   },
          // ),
          TextFormField(
            controller: emailController,
            validator: (String? value) {
              if (value != null) {
                return !GetUtils.isEmail(value)
                    ? "Please Enter valid email"
                    : null;
              }
              return "Email is required";
            },

            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            // autofocus: true,
            maxLines: null,
            cursorColor: myColors.theme_turquoise,

            style: TextStyle(
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Email",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
            ),
          ),
          10.h.verticalSpace,
          // buildTextField(
          //   Icons.phone,
          //   "Phone",
          //   false,
          //   true,
          //   phoneController,
          //   (val) {
          //     if (val!.isValidPhone) return 'Please enter a valid phone number';
          //   },
          // ),
          TextFormField(
            controller: phoneController,
            validator: (val) {
              if (val!.isValidPhone) return 'Please enter a valid phone number';
              return null;
            },

            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            // autofocus: true,
            maxLines: null,
            cursorColor: myColors.theme_turquoise,

            style: TextStyle(
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Phone",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(Icons.phone, color: Colors.grey[500]),
            ),
          ),
          10.h.verticalSpace,
          // buildTextField(
          //   Icons.numbers,
          //   "Registeration No",
          //   false,
          //   true,
          //   registrationNumberController,
          //   (val) {
          //     if (val!.isValidRef) return 'Please enter a valid Reference Code';
          //   },
          // ),
          TextFormField(
            controller: registrationNumberController,
            validator: (val) {
              if (val!.isValidRef) return 'Please enter a valid Reference Code';
              return null;
            },

            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            // autofocus: true,
            maxLines: null,
            cursorColor: myColors.theme_turquoise,

            style: TextStyle(
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Registeration number",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(Icons.numbers, color: Colors.grey[500]),
            ),
          ),
          // buildTextField(
          //   Icons.account_box,
          //   "Missions & Objectives",
          //   false,
          //   false,
          //   missionController,
          //   (val) {
          //     if (val!.isValidName) return 'Please enter a valid phone number';
          //   },
          // ),
          10.h.verticalSpace,
          TextFormField(
            controller: missionController,
            validator: (val) {
              if (val!.isValidName) return 'Please enter a valid phone number';
              return null;
            },

            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            // autofocus: true,
            maxLines: null,
            cursorColor: myColors.theme_turquoise,

            style: TextStyle(
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Missions & Objectives",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(Icons.account_box, color: Colors.grey[500]),
            ),
          ),
          10.h.verticalSpace,
          TextFormField(
            obscureText: true,
            controller: signuppass,
            validator: (String? value) {
              if (value != null) {
                if (value.isEmpty) {
                  return "Password is required!";
                }
                return value.length < 8 ? "Minimum 6 character required" : null;
              }
              return "Password is required!";
            },

            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            // autofocus: true,
            // maxLines: null,
            cursorColor: myColors.theme_turquoise,

            style: TextStyle(
              fontSize: 16.sp,
            ),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Password",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 0, horizontal: 8.w),
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
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[500],
              ),
              prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500]),
            ),
          ),
          10.h.verticalSpace,
          MyTextFormField(
            prefixIcon: Icon(Icons.upload, color: Colors.grey[500]),
            readOnly: true,
            hintText: "KYC Documents",
            onTap: () async {
              pickFile();
            },
          ),

          /// gridviewwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
          GridView.builder(
            shrinkWrap: true,
            itemCount: selectedFileList.length,
            padding: EdgeInsets.symmetric(
              vertical: 20.h,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,
              crossAxisCount: 4,
              crossAxisSpacing: 10.w,
            ),
            itemBuilder: (context, index) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 0.058.sh,
                    width: 83.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(
                              File(selectedFileList[index].path.toString()),
                            ),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10.r),
                        color: myColors.theme_turquoise),
                  ),
                  Positioned(
                    left: 20.w,
                    bottom: 35.h,
                    child: GestureDetector(
                      onTap: () {
                        selectedFileList.removeAt(index);
                        setState(() {});
                      },
                      child: badges.Badge(
                          badgeStyle: const badges.BadgeStyle(
                            badgeColor: Colors.white10,
                          ),
                          badgeContent: Icon(
                            Icons.cancel,
                            color: myColors.theme_turquoise,
                          )),
                    ),
                  ),
                ],
              );
            },
          ),
          // buildTextField(
          //   Icons.lock_outline,
          //   "Password",
          //   true,
          //   false,
          //   signuppass,
          //   (String? value) {
          //     if (value != null) {
          //       if (value.isEmpty) {
          //         return "Password is required!";
          //       }
          //       return value.length < 8 ? "Minimum 6 character required" : null;
          //     }
          //     return "Password is required!";
          //   },
          // ),
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
