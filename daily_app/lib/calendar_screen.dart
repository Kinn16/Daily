import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _events = {
    DateTime(2024, 9, 23): ['Làm bài kiểm tra chất lượng', 'Họp nhóm'],
    DateTime(2024, 9, 24): ['Dự án cuối kỳ', 'Gặp giáo viên hướng dẫn'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Thay đổi thứ tự công việc trong ngày đã chọn
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final eventList = _getEventsForDay(_selectedDay ?? DateTime.now());
      final String movedEvent = eventList.removeAt(oldIndex);
      eventList.insert(newIndex, movedEvent);
      _events[_selectedDay!] =
          eventList; // Cập nhật danh sách công việc trong _events
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Hiển thị công việc cho ngày đã chọn
          Expanded(
            child: ReorderableListView(
              onReorder: _onReorder, // Gọi hàm thay đổi thứ tự
              children: _getEventsForDay(_selectedDay ?? DateTime.now())
                  .map((event) => ListTile(
                        key: ValueKey(event), // Cần có key cho mỗi item
                        title: Text(event),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
