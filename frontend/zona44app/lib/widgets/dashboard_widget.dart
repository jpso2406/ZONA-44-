import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';

class DashboardWidget extends StatelessWidget {
  final DashboardData data;

  const DashboardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCard('Ventas del día', data.ventasDia.toString(), Icons.today),
        _buildCard('Ventas de la semana', data.ventasSemana.toString(), Icons.calendar_view_week),
        _buildCard('Ventas del mes', data.ventasMes.toString(), Icons.calendar_today),
        _buildCard('Total generado (mes)', '\$${data.totalGeneradoMes}', Icons.attach_money),
        _buildCard('Producto más vendido', data.productoMasVendido, Icons.star),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        subtitle: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
