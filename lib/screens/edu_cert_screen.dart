import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/candidate.dart';
import '../providers/account_provider.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';

/// 学历证书展示区，查看需 100 积分解锁。
class EduCertScreen extends StatelessWidget {
  final Candidate candidate;
  const EduCertScreen({super.key, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    final key = 'edu:${candidate.id}';
    final unlocked = account.hasUnlocked(key);
    return Scaffold(
      appBar: AppBar(title: const Text('学历证书')),
      body: unlocked ? _cert(candidate) : _paywall(context, account, key),
    );
  }

  Widget _cert(Candidate c) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF0D47A1)]),
              ),
              child: const Center(
                child: Icon(Icons.school, color: Colors.white, size: 60),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('学历认证',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    _row('编号', 'C${c.id.replaceAll('C', '')}'),
                    _row('学历', c.education),
                    _row('毕业院校', '${_school(c.education)}（模拟）'),
                    _row('认证状态', '已通过人工审核 ✓', color: AppTheme.success),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  static String _school(String edu) {
    if (edu.contains('硕士')) return '某重点大学';
    if (edu.contains('本科')) return '某本科院校';
    return '某院校';
  }

  Widget _row(String k, String v, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(k,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 13)),
            ),
            Expanded(
              child: Text(v,
                  style: TextStyle(fontSize: 13, color: color)),
            ),
          ],
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
              const Text('学历证书已加密',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('解锁需 ${AppConfig.unlockCostPoints} 积分',
                  style: const TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              if (account.points >= AppConfig.unlockCostPoints)
                ElevatedButton(
                  onPressed: () {
                    if (account.unlock(key, AppConfig.unlockCostPoints,
                        '查看${candidate.education}学历证书')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('已解锁学历证书')));
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
