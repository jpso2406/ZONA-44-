import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  // Datos simulados de ventas por mes
  final List<Map<String, dynamic>> ventasPorMes = const [
    {'label': 'Ene', 'value': 10.0},
    {'label': 'Feb', 'value': 20.0},
    {'label': 'Mar', 'value': 15.0},
    {'label': 'Abr', 'value': 30.0},
    {'label': 'May', 'value': 25.0},
    {'label': 'Jun', 'value': 40.0},
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < ventasPorMes.length) {
                      return Text(ventasPorMes[index]['label']);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                barWidth: 3,
                color: Colors.orange,
                spots: List.generate(
                  ventasPorMes.length,
                  (index) => FlSpot(
                    index.toDouble(),
                    ventasPorMes[index]['value'],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
