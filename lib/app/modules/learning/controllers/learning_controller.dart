import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';

import '../views/categorymodel.dart';


class LearningController extends GetxController {

  RxList<Datum> categories = <Datum>[].obs;




  @override
void onInit() {
  super.onInit();
  loadCategories(); 
}
  Future<void> loadCategories() async {
    categories.value = await fetchCategories();
  }

  Future<List<Datum>> fetchCategories() async {
    List<Datum> categoryList = [];

    try {
      final response = await dioPost(
        isPost: false,
        endUrl: 'https://saptahikgyan.in/admin/api/getcategory.php',
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          for (var item in data['data']) {
            categoryList.add(Datum.fromMap(item));
          }
        } else {
          debugPrint("API returned error: ${data['message']}");
        }
      } else {
        debugPrint("HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception in fetchCategories: $e");
    }

    return categoryList;
  }
  void onCategoryTap(Datum category) {
  // Use full category data
  Get.snackbar("Selected", category.name);
}
}