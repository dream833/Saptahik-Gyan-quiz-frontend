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
      appBar: AppBar(
        title: const Text("🏆 Leaderboard"),
        backgroundColor: AppColor.buttonOneColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Step 1: show quizzes
        if (controller.quizzes.isNotEmpty && controller.leaderboard.isEmpty) {
          return ListView.builder(
            itemCount: controller.quizzes.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final quiz = controller.quizzes[index];
              return Card(
                child: ListTile(
                  title: Text(quiz["title"]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    controller.fetchLeaderboard(
                        selectedDate, int.parse(quiz["quiz_id"]));
                  },
                ),
              );
            },
          );
        }

        // Step 2: show leaderboard
        if (controller.leaderboard.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Rank")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Score")),
                DataColumn(label: Text("Correct")),
                DataColumn(label: Text("Wrong")),
                DataColumn(label: Text("Time")),
              ],
              rows: controller.leaderboard.map<DataRow>((player) {
                return DataRow(cells: [
                  DataCell(Text("#${player["rank"]}")),
                  DataCell(Text(player["name"])),
                  DataCell(Text(player["score"])),
                  DataCell(Text(player["correct_answers"])),
                  DataCell(Text(player["wrong_answers"])),
                  DataCell(Text("${player["time_taken"]}s")),
                ]);
              }).toList(),
            ),
          );
        }

        return const Center(child: Text("❌ No data found"));
      }),
    );
  }
}