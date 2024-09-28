import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Import provider từ main

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cài Đặt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Thêm khoảng cách bên ngoài
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
          children: [
            const Text(
              'Chọn Chế Độ Giao Diện',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold), // Đặt tiêu đề cho phần cài đặt
            ),
            const SizedBox(height: 20), // Khoảng cách giữa tiêu đề và công tắc
            ListTile(
              title: const Text('Chế Độ Tối'),
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            // Có thể thêm các tùy chọn khác tại đây
          ],
        ),
      ),
    );
  }
}
