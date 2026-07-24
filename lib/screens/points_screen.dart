import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/account_provider.dart';
import '../services/ad_service.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('我的积分')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _balanceCard(account),
            const SizedBox(height: 16),
            _earnCard(context, account),
            const SizedBox(height: 16),
            _rechargeCard(context, account),
            const SizedBox(height: 16),
            _historyCard(account),
          ],
        ),
      ),
    );
  }

  Widget _balanceCard(AccountProvider a) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFFC2185B)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text('当前积分',
                style: TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 8),
            Text('${a.points}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('≈ ¥${(a.points / AppConfig.pointsPerYuan).toStringAsFixed(2)}',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.85), fontSize: 13)),
          ],
        ),
      );

  Widget _earnCard(BuildContext context, AccountProvider a) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('赚取积分',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_circle,
                      color: AppTheme.secondary),
                ),
                title: const Text('看广告赚积分'),
                subtitle: const Text('观看一个激励视频 +300 积分'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    final got = await AdService.watchAd(context);
                    if (got > 0) {
                      a.earn(got, '观看广告');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('+$got 积分到账')));
                    }
                  },
                  child: const Text('看广告'),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      );

  Widget _rechargeCard(BuildContext context, AccountProvider a) {
    final options = [1.0, 6.0, 18.0, 30.0];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('限量充值',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const Spacer(),
                Text('剩余额度 ¥${a.rechargedRemainingYuan}',
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('100 积分 = 0.01 元（演示，未接支付）',
                style:
                    TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((yuan) {
                final pts = (yuan * AppConfig.pointsPerYuan).round();
                final disabled = !a.canRechargeMore;
                return ElevatedButton(
                  onPressed: disabled
                      ? null
                      : () {
                          if (a.recharge(yuan)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '充值 ¥${yuan.toStringAsFixed(2)} → +$pts 积分')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已达充值上限 ¥100')));
                          }
                        },
                  child: Text('¥${yuan.toStringAsFixed(0)} / $pts'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(AccountProvider a) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('积分明细',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              if (a.transactions.isEmpty)
                const Text('暂无记录',
                    style: TextStyle(color: AppTheme.textSecondary)),
              ...a.transactions.take(30).map((t) {
                final isEarn = t.type != 'spend';
                final sign = isEarn ? '+' : '-';
                final color = isEarn ? AppTheme.success : AppTheme.error;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(isEarn ? Icons.add_circle : Icons.remove_circle,
                          color: color, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.reason, style: const TextStyle(fontSize: 13)),
                            Text(
                              DateFormat('MM-dd HH:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      t.timestamp)),
                              style: const TextStyle(
                                  fontSize: 11, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Text('$sign${t.amount}',
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
}
