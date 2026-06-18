import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/SignUp/controllers/sign_up_controller.dart';
import 'package:quiz/app/modules/sign_in/views/sign_in_view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        toolbarHeight: 1.sp,
      ),
      backgroundColor: const Color(0xFFFCF6E7),

      /// 🔥 STACK FOR LOADER
      body: Stack(
        children: [
          /// MAIN UI
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.sp),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// TITLE
                      Text(
                        "Welcome to",
                        style: GoogleFonts.pacifico(
                          textStyle: TextStyle(
                            fontSize: 30.sp,
                            letterSpacing: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        "Daily Bengali Quiz : WB PATHSHALA ",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          "Cairo Play",
                          textStyle: TextStyle(
                            fontSize: 50.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2.sp,
                            color: const Color(0xFF2E3A59),
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      Text(
                        "জ্ঞান যেখানে প্রতিদিন নতুন",
                        style: GoogleFonts.tiroBangla(
                          fontWeight: FontWeight.bold,
                          fontSize: 37.sp,
                          letterSpacing: 1.1,
                          color: const Color(0xFF2E3A59),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// NAME
                      _buildTextField(
                        controller.nameController,
                        "Name",
                        Icons.person,
                      ),

                      /// EMAIL
                      _buildTextField(
                        controller.emailController,
                        "Email address",
                        Icons.email,
                      ),

                      /// MOBILE
                      _buildTextField(
                        controller.mobileController,
                        "Mobile no.",
                        Icons.phone,
                        maxLength: 10,
                      ),

                      /// PASSWORD
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(bottom: 26.sp),
                          child: TextField(
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordHidden.value,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: "Password",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.sp),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordHidden.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  controller.isPasswordHidden.toggle();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12.h),

                      /// BUTTONS
                      Column(
                        children: [
                          /// SIGN UP BUTTON (PREMIUM BIG BUTTON)
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              height: 28.h,
                              child: ElevatedButton(
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.signUp,
                                style: ElevatedButton.styleFrom(
                                  elevation: 6,
                                  backgroundColor: AppColor.buttonOneColor,
                                  shadowColor: Colors.brown.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.sp),
                                  ),
                                ),
                                child: Text(
                                  controller.isLoading.value
                                      ? "Please wait..."
                                      : "SIGN UP",
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24.h),

                          /// SIGN IN TEXT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You have an account? ",
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Get.to(SignInView());
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.buttonTwoColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🔥 FULL SCREEN LOADER
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  /// TEXT FIELD
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    int? maxLength,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 26.sp),
      child: TextField(
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.sp),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  /// BUTTON
  Widget _buildButton({
    required String text,
    VoidCallback? onTap,
    Color? color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
