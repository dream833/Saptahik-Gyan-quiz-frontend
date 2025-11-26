import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/joinwithus_controller.dart';

class JoinwithusView extends GetView<JoinwithusController> {
  const JoinwithusView({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color, width: 2),
        ),
        child: Center(child: FaIcon(icon, color: color, size: 35)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Join With Us"),
        centerTitle: true,
        backgroundColor: AppColor.buttonOneColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Follow & Join Our Community",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                socialButton(
                  icon: FontAwesomeIcons.facebookF,
                  color: Colors.blue,
                  onTap:
                      () => _launchUrl(
                        "https://www.facebook.com/share/1BnvWcMxzZ/",
                      ),
                ),
                const SizedBox(width: 25),
                socialButton(
                  icon: FontAwesomeIcons.instagram,
                  color: Colors.pink,
                  onTap:
                      () => _launchUrl(
                        "https://www.instagram.com/daily_bengali_quiz_?igsh=MW9mbzMwdDJ1Z3pwag==",
                      ),
                ),
                const SizedBox(width: 25),
                socialButton(
                  icon: FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  onTap:
                      () => _launchUrl(
                        "https://chat.whatsapp.com/JUxEQv6u0MY1sjMt7QkSsG",
                      ),
                ),
              ],
            ),

            const SizedBox(height: 40),
            Text(
              "Stay Connected Always",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppColor.buttonOneColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
