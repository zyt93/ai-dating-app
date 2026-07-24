import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../services/gift_service.dart';
import '../theme/app_theme.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('礼物商城')),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: '购买赠送'),
                Tab(text: '我的礼物/兑换'),
              ],
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _BuyTab(),
                  _InventoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: GiftService.catalog.length,
      itemBuilder: (_, i) {
        final g = GiftService.catalog[i];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(g.emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(g.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(g.description,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textSecondary)),
                const Spacer(),
                Text('${g.costPoints} 积分',
                    style: const TextStyle(
                        color: AppTheme.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (account.buyGift(g)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('已购买 ${g.name}，可在聊天中赠送')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('积分不足')));
                      }
                    },
                    child: const Text('购买'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InventoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    final owned = GiftService.catalog
        .where((g) => (account.gifts[g.id] ?? 0) > 0)
        .toList();
    if (owned.isEmpty) {
      return const Center(
        child: Text('背包暂无礼物，去「购买赠送」页购买吧',
            style: TextStyle(color: AppTheme.textSecondary)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: owned.length,
      itemBuilder: (_, i) {
        final g = owned[i];
        final count = account.gifts[g.id] ?? 0;
        return Card(
          child: ListTile(
            leading: Text(g.emoji, style: const TextStyle(fontSize: 30)),
            title: Text('${g.name} ×$count'),
            subtitle: Text('兑换可回 ${g.redeemPoints} 积分'),
            trailing: ElevatedButton(
              onPressed: () {
                if (account.redeemGift(g)) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('兑换 +${g.redeemPoints} 积分')));
                }
              },
              child: const Text('兑换积分'),
            ),
          ),
        );
      },
    );
  }
}
