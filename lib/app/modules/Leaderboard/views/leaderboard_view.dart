import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/app/data/config/appcolor.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends StatelessWidget {
  final String selectedDate;
  LeaderboardView({super.key, required this.selectedDate});

  final LeaderboardController controller = Get.put(LeaderboardController());

  @override
  Widget build(BuildContext context) {
    controller.fetchQuizzes(selectedDate);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("🏆 Leaderboard"),
        backgroundColor: AppColor.buttonOneColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Step 1: show quizzes
        if (controller.quizzes.isNotEmpty && controller.leaderboard.isEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.quizzes.length,
            itemBuilder: (context, index) {
              final quiz = controller.quizzes[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    quiz["title"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    controller.fetchLeaderboard(
                        selectedDate, int.parse(quiz["quiz_id"]));
                  },
                ),
              );
            },
          );
        }

        // Step 2: show leaderboard table
        if (controller.leaderboard.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: DataTable(
                headingRowHeight: 50,
                dataRowHeight: 60,
                columnSpacing: 24,
                headingRowColor: MaterialStateProperty.all(
                  AppColor.buttonOneColor.withOpacity(0.9),
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                dividerThickness: 0.5,
                showBottomBorder: true,
                columns: const [
                  DataColumn(label: Text("Rank")),
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Score")),
                  DataColumn(label: Text("Time")),
                ],
                rows: List.generate(controller.leaderboard.length, (index) {
                  final player = controller.leaderboard[index];
                  int rank = int.tryParse(player["rank"].toString()) ?? 0;

                  // rank color logic
                  Color rankColor;
                  if (rank == 1) {
                    rankColor = Colors.amber;
                  } else if (rank == 2) {
                    rankColor = Colors.grey;
                  } else if (rank == 3) {
                    rankColor = Colors.brown;
                  } else {
                    rankColor = AppColor.buttonOneColor;
                  }

                  return DataRow(
                    color: MaterialStateProperty.all(
                      index.isEven ? Colors.grey[50] : Colors.white,
                    ),
                    cells: [
                      DataCell(
                        Text(
                          "#$rank",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rankColor,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          player["name"],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(Text(player["score"].toString())),
                      DataCell(Text("${player["time_taken"]}s")),
                    ],
                  );
                }),
              ),
            ),
          );
        }

        return const Center(child: Text("❌ No data found"));
      }),
    );
  }
}