import 'package:flutter/material.dart';
import '../app_theme.dart';

class Loading extends StatelessWidget {
  final String? message;
  const Loading({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        const CircularProgressIndicator(color: AppTheme.primary),
        if (message != null) ...[
          const SizedBox(height: 12),
          Text(message!, style: const TextStyle(color: Colors.black54)),
        ],
      ]),
    );
  }
}

class Empty extends StatelessWidget {
  final String title;
  final IconData icon;
  const Empty({super.key, required this.title, this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: Colors.black26, size: 48),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(color: Colors.black54)),
      ]),
    );
  }
}
