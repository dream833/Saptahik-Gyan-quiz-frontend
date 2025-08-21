import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz/app/data/config/function/dio_post.dart';
import 'package:quiz/app/modules/subcategory/views/subcategorymodel.dart';


class SubcategoryController extends GetxController {
  RxList<Subcategory> subcategories = <Subcategory>[].obs;
  RxBool isLoading = false.obs;

  Future<void> loadSubcategories(int categoryId) async {
    try {
      final response = await dioPost(
        isPost: true,
        endUrl: '/getsubcategory.php',
        data: {'category_id': categoryId},
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List<dynamic> data = response.data['data'];
        subcategories.value = data.map((e) => Subcategory.fromMap(e)).toList();
      } else {
        debugPrint("API error: ${response.data}");
      }
    } catch (e) {
      debugPrint("Fetch subcategories error: $e");
    }
  }
}