import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import 'package:quiz/app/modules/Question/views/question_view.dart';
import 'package:quiz/app/modules/subcategory/controllers/subcategory_controller.dart';

class SubCategoryPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const SubCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubcategoryController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadSubcategories(categoryId);
    });

    return Scaffold(
         backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.buttonOneColor,
        title: Text(
          categoryName,
          style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.subcategories.isEmpty) {
          return Center(
            child: Text(
              "No subcategories found",
              style: TextStyle(fontSize: 60.sp, color: Colors.grey),
            ),
          );
        }

        // Soft background colors list
        final List<Color> bgColors = [
          Colors.blue.shade50,
          Colors.green.shade50,
          Colors.purple.shade50,
          Colors.orange.shade50,
          Colors.teal.shade50,
          Colors.pink.shade50,
        ];

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          itemCount: controller.subcategories.length,
          itemBuilder: (context, index) {
            final sub = controller.subcategories[index];
            final bgColor = bgColors[index % bgColors.length]; // repeat colors

            return GestureDetector(
              onTap: () {
                Get.to(() => QuestionView(
                      categoryId: categoryId,
                      subCategoryId: sub.id,
                    ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 6.h),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        sub.name,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 40.sp,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}