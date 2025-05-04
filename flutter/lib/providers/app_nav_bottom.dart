import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final String currentRoute;

  const AppBottomNavBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'Home', '/homepage'),
          _buildNavItem(context, Icons.calculate, 'Calculadora', '/calculadora'),
          _buildNavItem(context, Icons.solar_power, 'Simulador', '/simulador'),
          _buildNavItem(context, Icons.map, 'Fornecedores', '/fornecedores'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, String route) {
    final isSelected = currentRoute == route;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? colorScheme.primary : colorScheme.onSurface),
          Text(label, style: TextStyle(color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
        ],
      ),
    );
  }
}