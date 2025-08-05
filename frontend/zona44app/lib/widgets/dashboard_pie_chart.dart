import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardPieChart extends StatelessWidget {
  const DashboardPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: _buildSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      PieChartSectionData(
        value: 35,
        title: 'Hamburguesas',
        color: Colors.deepOrange,
        radius: 60,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: 25,
        title: 'Perros',
        color: Colors.amber,
        radius: 55,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: 20,
        title: 'Tacos',
        color: Colors.teal,
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: 20,
        title: 'Otros',
        color: Colors.indigo,
        radius: 50,
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ];
  }
}
