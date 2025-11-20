import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/contactus_controller.dart';

class ContactusView extends GetView<ContactusController> {
  const ContactusView({super.key});

  final String whatsappUrl =
      "https://wa.me/+919332489941?text=Hi,%20I%20would%20like%20to%20know%20more";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
        backgroundColor: AppColor.buttonOneColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We’re here to help!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 16),

              Text(
                "If you have any questions, suggestions, or need support, "
                "feel free to reach out to us using the contact details below:",
                style: TextStyle(fontSize: 16, height: 1.4),
              ),

              SizedBox(height: 20),

              Text(
                "📧 Email:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text("support@wbpathshala.com", style: TextStyle(fontSize: 16)),

              SizedBox(height: 20),

              Text(
                "🌐 Website:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text("www.wbpathshala.com", style: TextStyle(fontSize: 16)),

              SizedBox(height: 20),

              Text(
                "📱 WhatsApp:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              InkWell(
                onTap: () async {
                  if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                    await launchUrl(
                      Uri.parse(whatsappUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  } else {
                    Get.snackbar("Error", "Cannot open WhatsApp link");
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Chat on WhatsApp",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              Text(
                "We aim to respond within 24 hours.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
