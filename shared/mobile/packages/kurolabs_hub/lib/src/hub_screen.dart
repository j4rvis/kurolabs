import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'module_config.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({
    super.key,
    this.modules = ModuleConfig.all,
  });

  final List<ModuleConfig> modules;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KuroLabs')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          return GestureDetector(
            onTap: () => context.go(module.path),
            child: Card(
              color: module.color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(module.icon, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    module.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
