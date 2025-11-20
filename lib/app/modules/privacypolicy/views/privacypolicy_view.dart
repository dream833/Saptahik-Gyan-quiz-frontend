import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import '../controllers/privacypolicy_controller.dart';

class PrivacypolicyView extends GetView<PrivacypolicyController> {
  const PrivacypolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        backgroundColor: AppColor.buttonOneColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              Text(
                "Last updated : [18.11.2025]",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 20),

              Text(
                "Welcome to Daily Bengali Quiz : WB PATHSHALA.\n\n"
                "Your privacy is important to us. This Privacy Policy explains how we "
                "collect, use, and protect your information when you use our app.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "1. Information We Collect",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "We may collect the following types of information:\n\n"
                "• Personal Information: Such as your name, email address, or phone number "
                "(only if you choose to provide it).\n\n"
                "• Usage Data: Information about how you use our app, including quiz participation, "
                "time spent, and preferences.\n\n"
                "We do not collect any sensitive personal data without your consent.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "2. How We Use Your Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "We use your information to:\n\n"
                "• Provide and improve our services.\n"
                "• Personalize your quiz and learning experience.\n"
                "• Send important updates or notifications.\n"
                "• Maintain app performance and fix issues.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "3. Data Security",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "We take appropriate security measures to protect your data against unauthorized "
                "access, alteration, disclosure, or destruction.\n\n"
                "However, please remember that no method of electronic transmission or storage "
                "is 100% secure.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "4. Third-Party Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "Our app may use third-party services such as:\n\n"
                "• Google AdMob (for showing ads)\n"
                "• Firebase Analytics (for app performance and crash reports)\n\n"
                "These third-party services may collect data as per their own privacy policies.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "5. Children’s Privacy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "Our app is designed for general users and does not knowingly collect personal "
                "data from children under 13 years of age.\n\n"
                "If you believe your child has provided personal information, please contact us, "
                "and we will take steps to remove it.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "6. Changes to This Privacy Policy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                "We may update our Privacy Policy from time to time.\n"
                "Any changes will be posted on this page with a new \"Last updated\" date.",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
