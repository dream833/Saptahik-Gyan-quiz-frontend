import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/special_question_list_controller.dart';

class SpecialQuestionListView extends StatelessWidget {
  const SpecialQuestionListView({super.key});

  // A palette of 12 solid colors (you can tweak these)
  static const List<Color> _palette = [
    Color(0xFF1F77B4), // blue
    Color(0xFF2CA02C), // green
    Color(0xFFFF7F0E), // orange
    Color(0xFFD62728), // red
    Color(0xFF9467BD), // purple
    Color(0xFF8C564B), // brown
    Color(0xFFE377C2), // pink
    Color(0xFF7F7F7F), // gray
    Color(0xFF17BECF), // teal
    Color(0xFFBCBD22), // olive
    Color(0xFF393B79), // indigo
    Color(0xFF637939), // dark olive
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SpecialQuestionListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Special Question List"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF6F7FB),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.titles.isEmpty) {
          return const Center(
            child: Text(
              "No titles found",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.titles.length,
          itemBuilder: (context, index) {
            final item = controller.titles[index];
            final Color bg = _palette[index % _palette.length];

            return GestureDetector(
              onTap: () {
                Get.toNamed(
  '/special-question-detail',
  arguments: {
    'titleId': item.id,
    'title': item.title,
  },
);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Left color stripe (thin)
                    Container(
                      width: 8,
                      height: 72,
                      decoration: BoxDecoration(
                        color: darken(bg, 0.12),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title text (no numbers)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Chevron
                    const Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white70,
                      ),
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

  // small helper to darken a color (for the stripe)
  static Color darken(Color c, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final h = c;
    return Color.fromARGB(
      h.alpha,
      (h.red * (1 - amount)).round(),
      (h.green * (1 - amount)).round(),
      (h.blue * (1 - amount)).round(),
    );
  }
}