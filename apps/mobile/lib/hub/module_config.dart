import 'package:flutter/material.dart';

class ModuleConfig {
  const ModuleConfig({
    required this.name,
    required this.path,
    required this.color,
    required this.icon,
  });

  final String name;
  final String path;
  final Color color;
  final IconData icon;

  static const List<ModuleConfig> all = [
    ModuleConfig(
      name: 'Questify',
      path: '/questify',
      color: Color(0xFF7F77DD),
      icon: Icons.quiz_outlined,
    ),
  ];
}
