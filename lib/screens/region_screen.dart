import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';

/// 定位与地区范围设置。先覆盖国内，开启全球后纳入海外。
class RegionScreen extends StatelessWidget {
  const RegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    final regions = LocationService.regionsForScope(account.regionScope);
    return Scaffold(
      appBar: AppBar(title: const Text('定位与范围')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('覆盖范围',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const Spacer(),
                ToggleButtons(
                  isSelected: [
                    account.regionScope == 'domestic',
                    account.regionScope == 'global',
                  ],
                  onPressed: (i) {
                    final newScope = i == 0 ? 'domestic' : 'global';
                    final newRegions =
                        LocationService.regionsForScope(newScope);
                    final newRegion =
                        newRegions.contains(account.currentRegion)
                            ? account.currentRegion
                            : '全国';
                    account.setRegion(newScope, newRegion);
                  },
                  children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('国内')),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('全球')),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('先覆盖国内，开启全球后可匹配海外用户',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: regions.length,
              itemBuilder: (_, i) {
                final r = regions[i];
                final selected = account.currentRegion == r;
                return GestureDetector(
                  onTap: () {
                    account.setRegion(account.regionScope, r);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(r,
                          style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppTheme.textPrimary,
                              fontSize: 13)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
