import 'package:daily_app/intro_screen.dart';
import 'package:daily_app/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'task_list_screen.dart';
import 'add_task_screen.dart';
import 'calendar_screen.dart';
import 'task_statistics_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Daily Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Áp dụng Material Design 3
      ),
      darkTheme: ThemeData.dark(), // Cấu hình chế độ tối
      themeMode: themeProvider.themeMode, // Sử dụng themeMode từ provider
      initialRoute: '/intro', // Đặt màn hình intro là màn hình đầu tiên
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/login': (context) => const LoginScreen(),
        '/taskList': (context) => TaskListScreen(
              onThemeChanged: (bool) {},
            ),
        '/addTask': (context) => AddTaskScreen(onAddTask: (task) {
              // Xử lý thêm công việc ở đây
            }),
        '/calendar': (context) => const CalendarScreen(),
        '/statistics': (context) => const TaskStatisticsScreen(),
        '/settings': (context) =>
            const SettingsScreen(), // Thêm route cho SettingsScreen
      },
    );
  }
}

// ThemeProvider class
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Gọi notifyListeners() để cập nhật giao diện
  }
}
