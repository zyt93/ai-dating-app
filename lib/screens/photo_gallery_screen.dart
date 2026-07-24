import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/candidate.dart';
import '../providers/account_provider.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';

/// 相册（照片展示区），查看需 100 积分解锁。解锁后展示占位相片。
class PhotoGalleryScreen extends StatelessWidget {
  final Candidate candidate;
  const PhotoGalleryScreen({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    final key = 'photo:${candidate.id}';
    final unlocked = account.hasUnlocked(key);
    return Scaffold(
      appBar: AppBar(title: const Text('相册')),
      body: unlocked ? _gallery() : _paywall(context, account, key),
    );
  }

  Widget _gallery() => GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.8),
                AppTheme.secondary.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo,
                    color: Colors.white, size: 40),
                const SizedBox(height: 8),
                Text('照片 ${i + 1}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      );

  Widget _paywall(BuildContext context, AccountProvider account, String key) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 64, color: AppTheme.divider),
              const SizedBox(height: 20),
              const Text('相册已加密',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('解锁需 ${AppConfig.unlockCostPoints} 积分',
                  style: const TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              if (account.points >= AppConfig.unlockCostPoints)
                ElevatedButton(
                  onPressed: () {
                    if (account.unlock(
                        key, AppConfig.unlockCostPoints, '查看${candidate.occupation}相册')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已解锁相册')));
                    }
                  },
                  child: Text('解锁 · ${AppConfig.unlockCostPoints}积分'),
                )
              else
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/points'),
                  child: const Text('去赚积分'),
                ),
            ],
          ),
        ),
      );
}
