import 'package:flutter/material.dart';

/// 模拟激励视频广告。生产环境请接入 google_mobile_ads(AdMob) 或国内穿山甲/优量汇 SDK。
/// 观看完成后返回奖励积分数（默认 300）。
class AdService {
  static Future<int> watchAd(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const _AdDialog(),
    );
    return result ?? 0;
  }
}

class _AdDialog extends StatefulWidget {
  const _AdDialog();

  @override
  State<_AdDialog> createState() => _AdDialogState();
}

class _AdDialogState extends State<_AdDialog> {
  int _remaining = 5;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      if (_remaining > 1) {
        setState(() => _remaining--);
        _tick();
      } else {
        setState(() => _remaining = 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('观看广告赚取积分'),
      content: SizedBox(
        height: 180,
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('【广告位】\n模拟激励视频',
                    textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            Text(_remaining > 0 ? '广告播放中，剩余 $_remaining 秒…' : '广告播放完成，可领取奖励'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _remaining > 0 ? null : () => Navigator.pop(context, 300),
          child: Text(_remaining > 0 ? '请稍候…' : '领取 300 积分'),
        ),
      ],
    );
  }
}
