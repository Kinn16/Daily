import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TaskStatisticsScreen extends StatelessWidget {
  const TaskStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Hoàn Thành": 35,
      "Đang Hoàn Thành": 23,
      "Mới": 2,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê nhiệm vụ')),
      body: Center(
        child: PieChart(dataMap: dataMap),
      ),
    );
  }
}
