import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/config/app_cons.dart';
import '../../../../data/config/appcolor.dart';
import '../../../../data/function/dio_post.dart';
import '../../../../data/widgets/shimmer_widget.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final gradeController = TextEditingController();
  final bioController = TextEditingController();

  var isLoading = false.obs;
  var isSaving = false.obs;
  var selectedImageFile = Rx<File?>(null);
  var profileImageUrl = Rx<String?>(null);

  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final xFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (xFile != null) {
        selectedImageFile.value = File(xFile.path);
      }
    } catch (e) {
      log("Image pick error: $e");
    }
  }

  void showImagePickerOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.textLight,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Upload Profile Photo',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 20.h),
            Material(
              type: MaterialType.transparency,
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColor.buttonOneColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColor.buttonOneColor,
                  ),
                ),
                title: Text(
                  'Take Photo',
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColor.buttonTwoColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.photo_library_rounded,
                    color: AppColor.buttonTwoColor,
                  ),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: GoogleFonts.poppins(fontSize: 14.sp),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final userId = getBox.read(USER_ID);
      if (userId == null) return;

      final response = await dioPost(
        endUrl: "/fetch-profile.php",
        data: {"user_id": int.tryParse(userId.toString()) ?? 0},
      );

      log("Profile Response: ${response.data}");

      if (response.data['status'] == true && response.data['data'] != null) {
        final data = response.data['data'];
        nameController.text = data['full_name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['mobile'] ?? '';
        gradeController.text = data['class_grade'] ?? '';
        bioController.text = data['about_me'] ?? '';

        // Load profile image URL if available
        if (data['profile_image'] != null &&
            data['profile_image'].toString().isNotEmpty) {
          profileImageUrl.value = data['profile_image'].toString();
        }
      }
    } catch (e) {
      log("Fetch profile error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile(BuildContext context) async {
    try {
      isSaving.value = true;

      final userId = getBox.read(USER_ID);
      if (userId == null) return;

      // Build JSON body (server requires JSON+base64, not form-data)
      final Map<String, dynamic> body = {
        "user_id": int.tryParse(userId.toString()) ?? 0,
        "full_name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "mobile": phoneController.text.trim(),
        "address": "",
        "class_grade": gradeController.text.trim(),
        "about_me": bioController.text.trim(),
      };

      // Convert image to base64 data URI if selected
      if (selectedImageFile.value != null) {
        final bytes = await selectedImageFile.value!.readAsBytes();
        final b64 = base64Encode(bytes);
        final mime = _getMimeType(selectedImageFile.value!.path);
        body['profile_image'] = 'data:$mime;base64,$b64';
      }

      final response = await dioPost(
        endUrl: "/update-profile.php",
        data: body,
        // sendFile NOT set — sends as application/json
      );

      log("Save Profile Response: ${response.data}");

      if (response.data['status'] == true) {
        if (response.data['profile_image'] != null) {
          profileImageUrl.value = response.data['profile_image'].toString();
        }
        selectedImageFile.value = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_rounded, color: Colors.white, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Profile updated successfully!',
                  style: GoogleFonts.poppins(fontSize: 12.sp),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: AppColor.success,
            duration: const Duration(seconds: 2),
          ),
        );
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data['message'] ?? 'Failed to update profile',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColor.error,
          ),
        );
      }
    } catch (e) {
      log("Save profile error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColor.error,
        ),
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    gradeController.dispose();
    bioController.dispose();
    super.onClose();
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EditProfileController>()
        ? Get.find<EditProfileController>()
        : Get.put(EditProfileController());

    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColor.cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [AppColor.softShadow],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColor.buttonTwoColor,
                size: 22.sp,
              ),
            ),
          ),
          title: Text(
            'Edit Profile',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
            ),
          ),
          actions: [
            if (!controller.isLoading.value)
              GestureDetector(
                onTap: controller.isSaving.value
                    ? null
                    : () => controller.saveProfile(context),
                child: Container(
                  margin: EdgeInsets.all(8.r),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColor.primaryGradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: controller.isSaving.value
                      ? SizedBox(
                          width: 20.sp,
                          height: 20.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
          ],
        ),
        body: controller.isLoading.value
            ? SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    ShimmerWidget.circle(radius: 45),
                    SizedBox(height: 28.h),
                    ShimmerWidget.formField(),
                    SizedBox(height: 14.h),
                    ShimmerWidget.formField(),
                    SizedBox(height: 14.h),
                    ShimmerWidget.formField(),
                    SizedBox(height: 14.h),
                    ShimmerWidget.formField(),
                    SizedBox(height: 14.h),
                    ShimmerWidget.formField(height: 100),
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(20.r),
                child: Column(
                  children: [
                    // Avatar (tappable)
                    Center(
                      child: GestureDetector(
                        onTap: () => controller.showImagePickerOptions(context),
                        child: Stack(
                          children: [
                            Obx(() {
                              if (controller.selectedImageFile.value != null) {
                                return Container(
                                  width: 90.r,
                                  height: 90.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [AppColor.buttonShadow],
                                    image: DecorationImage(
                                      image: FileImage(
                                        controller.selectedImageFile.value!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                              if (controller.profileImageUrl.value != null) {
                                final resolvedUrl = _resolveImageUrl(
                                  controller.profileImageUrl.value!,
                                );
                                final initial =
                                    controller.nameController.text.isNotEmpty
                                    ? controller.nameController.text[0]
                                          .toUpperCase()
                                    : 'U';
                                return ClipOval(
                                  child: Image.network(
                                    resolvedUrl,
                                    width: 90.r,
                                    height: 90.r,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
                                      width: 90.r,
                                      height: 90.r,
                                      decoration: BoxDecoration(
                                        gradient: AppColor.primaryGradient,
                                        shape: BoxShape.circle,
                                        boxShadow: [AppColor.buttonShadow],
                                      ),
                                      child: Center(
                                        child: Text(
                                          initial,
                                          style: GoogleFonts.poppins(
                                            fontSize: 36.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                width: 90.r,
                                height: 90.r,
                                decoration: BoxDecoration(
                                  gradient: AppColor.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [AppColor.buttonShadow],
                                ),
                                child: Center(
                                  child: Text(
                                    controller.nameController.text.isNotEmpty
                                        ? controller.nameController.text[0]
                                              .toUpperCase()
                                        : 'U',
                                    style: GoogleFonts.poppins(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  color: AppColor.cardColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [AppColor.softShadow],
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: AppColor.buttonOneColor,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),

                    _buildField(
                      'Full Name',
                      controller.nameController,
                      Icons.person_outline_rounded,
                    ),
                    SizedBox(height: 14.h),
                    _buildField(
                      'Email Address',
                      controller.emailController,
                      Icons.email_outlined,
                    ),
                    SizedBox(height: 14.h),
                    _buildField(
                      'Phone Number',
                      controller.phoneController,
                      Icons.phone_outlined,
                    ),
                    SizedBox(height: 14.h),
                    _buildField(
                      'Class / Grade',
                      controller.gradeController,
                      Icons.school_outlined,
                    ),
                    SizedBox(height: 14.h),
                    _buildField(
                      'About Me',
                      controller.bioController,
                      Icons.info_outline_rounded,
                      maxLines: 3,
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
      ),
    );
  }

  String _resolveImageUrl(String url) {
    if (url.toLowerCase().startsWith('http')) return url;
    // API returns path like "uploads/profile/xyz.jpg" — just add base
    return '${BASE_URL.replaceAll('/Api/app', '/')}$url';
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [AppColor.softShadow],
        border: Border.all(color: AppColor.cardBorder),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: AppColor.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColor.buttonTwoColor, size: 20.sp),
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: AppColor.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}

String _getMimeType(String path) {
  final p = path.toLowerCase();
  if (p.endsWith('.png')) return 'image/png';
  if (p.endsWith('.webp')) return 'image/webp';
  if (p.endsWith('.gif')) return 'image/gif';
  return 'image/jpeg';
}
