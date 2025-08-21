import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import '../controllers/learning_controller.dart';

class LearningView extends GetView<LearningController> {
  LearningView({super.key});
  @override
  final LearningController controller = Get.put(LearningController());

  final String defaultImageUrl = 'assets/images/defaultimage.png'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        toolbarHeight: 15.0.h,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFCF6E7),
              Color(0xFFEADFB4),
              Color(0xFFD5C689),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.buttonOneColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    minimumSize: Size(Get.width / .4, 40.h),
                  ),
                  child: Text(
                    'Daily G.K',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 47.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Obx(() {
                    if (controller.categories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5.h,
                        crossAxisSpacing: 15.w,
                        childAspectRatio: 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.categories[index];

                        final String imageUrl = (item.image != null && item.image!.isNotEmpty)
                            ? "https://saptahikgyan.in/admin/api/${item.image}"
                            : "";

                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              '/subcategory',
                              arguments: {
                                'categoryId': item.id,
                                'categoryName': item.name,
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: imageUrl.isNotEmpty
                                      ? Image.network(
                                          imageUrl,
                                          height: 30.h,
                                          width: 400.w,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              defaultImageUrl,
                                              height: 30.h,
                                              width: 400.w,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          defaultImageUrl,
                                          height: 30.h,
                                          width: 400.w,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                SizedBox(height: 7.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Text(
                                    item.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade900,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}