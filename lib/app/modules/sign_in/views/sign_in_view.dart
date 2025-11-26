import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/ForgetPassword/views/forget_password_view.dart';
import 'package:quiz/app/modules/SignUp/views/sign_up_view.dart';
import 'package:quiz/app/modules/sign_in/controllers/sign_in_controller.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(),
        backgroundColor: AppColor.backgroundColor,
        toolbarHeight: 1.sp,
      ),
      backgroundColor: const Color(0xFFFCF6E7),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.sp),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome back",
                    style: GoogleFonts.pacifico(
                      textStyle: TextStyle(
                        fontSize: 32.sp,
                        letterSpacing: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "SIGN IN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2.sp,
                      color: const Color(0xFF2E3A59),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // 🔹 TextFields
                  _buildTextField(
                    controller.mobileController,
                    "Mobile no.",
                    Icons.phone,
                  ),
                  _buildTextField(
                    controller.passwordController,
                    "Password",
                    Icons.lock,
                    obscureText: true,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.to(() => const ForgetPasswordView()),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Sign In Button
                  _buildButton(
                    text: "SIGN IN",
                    color: AppColor.buttonTwoColor,
                    onTap: controller.signIn,
                  ),

                  SizedBox(height: 20.h),

                  // 🔹 Sign Up Link
                  GestureDetector(
                    onTap: () => Get.to(() => const SignUpView()),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25.sp,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.sp),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
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

  Widget _buildButton({
    required String text,
    VoidCallback? onTap,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
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
    );
  }
}
