import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'add_task_screen.dart';
import 'calendar_screen.dart';
import 'task_statistics_screen.dart';
import 'login_screen.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const TaskListScreen({super.key, required this.onThemeChanged});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Map<String, String>> _tasks = []; // Danh sách các công việc
  int _selectedIndex = 0; // Chỉ số của tab được chọn
  bool isDarkMode = false; // Trạng thái chế độ tối
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Khởi tạo danh sách công việc với các công việc mẫu
    _tasks.addAll([
      {
        'taskTitle': 'Học tập',
        'date': '2024-09-28',
        'startTime': '08:00',
        'endTime': '10:00'
      },
      {
        'taskTitle': 'Chơi thể thao',
        'date': '2024-09-28',
        'startTime': '10:30',
        'endTime': '12:00'
      },
      {
        'taskTitle': 'Chạy bộ',
        'date': '2024-09-28',
        'startTime': '17:00',
        'endTime': '18:00'
      },
      {
        'taskTitle': 'Đọc sách',
        'date': '2024-09-28',
        'startTime': '19:00',
        'endTime': '20:00'
      },
      {
        'taskTitle': 'Giải trí',
        'date': '2024-09-28',
        'startTime': '20:30',
        'endTime': '22:00'
      },
    ]);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Thêm công việc mới
  void _addTask(Map<String, String> newTask) {
    setState(() {
      _tasks.add(newTask); // Thêm công việc mới vào danh sách
    });
    _showNotification(newTask['taskTitle']!, newTask['date']!); // Gửi thông báo
  }

  // Gửi thông báo
  Future<void> _showNotification(String taskTitle, String taskDate) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'Your channel description',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // ID thông báo
      'Công việc mới: $taskTitle', // Tiêu đề thông báo
      'Ngày: $taskDate', // Nội dung thông báo
      platformChannelSpecifics,
      payload: 'item x', // Có thể truyền thêm dữ liệu
    );
  }

  // Cập nhật công việc
  void _updateTask(int index, Map<String, String> updatedTask) {
    setState(() {
      _tasks[index] = updatedTask; // Cập nhật công việc
    });
  }

  // Xóa công việc
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index); // Xóa công việc
    });
  }

  // Thay đổi tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số tab được chọn
    });
  }

  // Chuyển đổi chế độ tối/sáng
  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode; // Đảo ngược trạng thái chế độ tối
      widget.onThemeChanged(isDarkMode); // Gọi hàm từ cha để cập nhật theme
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    // Chọn màn hình hiển thị dựa trên chỉ số tab được chọn
    switch (_selectedIndex) {
      case 0:
        currentScreen =
            _buildReorderableTaskList(); // Màn hình danh sách công việc kéo thả
        break;
      case 1:
        currentScreen = const CalendarScreen(); // Màn hình lịch
        break;
      case 2:
        currentScreen = const TaskStatisticsScreen(); // Màn hình thống kê
        break;
      default:
        currentScreen =
            _buildReorderableTaskList(); // Mặc định quay lại màn hình danh sách công việc
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planned'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Điều hướng đến màn hình thông báo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TaskListScreen(onThemeChanged: widget.onThemeChanged),
                ),
              );
            },
          ),
        ],
      ),
      body: currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Công Việc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thống Kê',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                onAddTask: _addTask,
              ), // Mở màn hình thêm công việc
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Danh Sách Công Việc Kéo Thả'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0); // Chọn tab danh sách công việc
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài Đặt'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, '/settings'); // Mở màn hình cài đặt
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Đăng Xuất'),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, '/login'); // Chuyển đến màn hình đăng xuất
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm xây dựng danh sách công việc có thể kéo thả
  Widget _buildReorderableTaskList() {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex--; // Điều chỉnh chỉ số khi kéo xuống
          }
          final Map<String, String> movedTask = _tasks.removeAt(oldIndex);
          _tasks.insert(newIndex, movedTask); // Sắp xếp lại công việc
        });
      },
      children: List.generate(_tasks.length, (index) {
        final task = _tasks[index];
        return ListTile(
          key: ValueKey(task['taskTitle']),
          title: Text(task['taskTitle'] ?? ''),
          subtitle: Text(
            'Ngày: ${task['date']}\nThời gian: ${task['startTime']} - ${task['endTime']}',
          ),
          onTap: () {
            // Điều hướng đến TaskDetailScreen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(
                  task: task,
                  onUpdateTask: (updatedTask) =>
                      _updateTask(index, updatedTask),
                  onDeleteTask: () => _deleteTask(index),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
