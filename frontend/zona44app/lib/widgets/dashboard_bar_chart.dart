import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardBarChart extends StatelessWidget {
  const DashboardBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          barGroups: _buildBarGroups(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getBottomTitles,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final List<double> values = [25, 40, 15, 30]; // Datos simulados
    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: Colors.deepOrange,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const titles = ['Hamb', 'Perro', 'Tacos', 'Otros'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        titles[value.toInt()],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
