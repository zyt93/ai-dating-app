import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _section('通用', [
            _tile('通知设置', Icons.notifications, () {}),
            _tile('隐私设置', Icons.privacy_tip, () {}),
            _tile('账号安全', Icons.security, () {}),
          ]),
          _section('关于', [
            _tile('版本信息', Icons.info, () {}),
            _tile('用户协议', Icons.description, () {}),
            _tile('隐私政策', Icons.policy, () {}),
            _tile('联系客服', Icons.support_agent, () {}),
          ]),
          _section('数据', [
            _tile('清除缓存', Icons.delete_outline, () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存已清除')),
              );
            }),
            _tile('退出登录', Icons.logout, () {}, isDestructive: true),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> tiles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(title, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
          child: Column(children: tiles),
        ),
      ],
    );
  }

  Widget _tile(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, size: 20, color: isDestructive ? AppTheme.error : AppTheme.primary),
      title: Text(title, style: TextStyle(fontSize: 15, color: isDestructive ? AppTheme.error : null)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}
