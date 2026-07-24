import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的匹配')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: AppTheme.divider),
            const SizedBox(height: 24),
            const Text('功能开发中', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('AI 配对聊天功能即将上线', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
