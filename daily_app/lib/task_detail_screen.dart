import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, String> task;
  final Function(Map<String, String>) onUpdateTask;
  final Function() onDeleteTask;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onUpdateTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: task['taskTitle']);
    final TextEditingController dateController =
        TextEditingController(text: task['date']);
    final TextEditingController startTimeController =
        TextEditingController(text: task['startTime']);
    final TextEditingController endTimeController =
        TextEditingController(text: task['endTime']);

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      }
    }

    Future<void> selectStartTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        startTimeController.text = picked.format(context);
      }
    }

    Future<void> selectEndTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        endTimeController.text = picked.format(context);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chi Tiết Công Việc')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            GestureDetector(
              onTap: () => selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Ngày'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => selectStartTime(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: startTimeController,
                  decoration:
                      const InputDecoration(labelText: 'Thời gian bắt đầu'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => selectEndTime(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: endTimeController,
                  decoration:
                      const InputDecoration(labelText: 'Thời gian kết thúc'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onUpdateTask({
                  'taskTitle': titleController.text,
                  'date': dateController.text,
                  'startTime': startTimeController.text,
                  'endTime': endTimeController.text,
                });
                Navigator.pop(context); // Quay lại danh sách
              },
              child: const Text('Cập Nhật Công Việc'),
            ),
            ElevatedButton(
              onPressed: () {
                onDeleteTask();
                Navigator.pop(context); // Quay lại danh sách
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Xóa Công Việc'),
            ),
          ],
        ),
      ),
    );
  }
}
