import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/candidate.dart';
import '../providers/account_provider.dart';
import '../providers/candidates_provider.dart';
import '../screens/photo_gallery_screen.dart';
import '../screens/edu_cert_screen.dart';
import '../config/app_config.dart';
import '../theme/app_theme.dart';

class CandidateDetailScreen extends StatelessWidget {
  const CandidateDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Candidate c = ModalRoute.of(context)!.settings.arguments as Candidate;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: c.gender == '女' ? AppTheme.primary : AppTheme.secondary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: c.gender == '女'
                        ? [AppTheme.primary, const Color(0xFFC2185B)]
                        : [AppTheme.secondary, const Color(0xFFE64A19)],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                        child: Icon(c.gender == '女' ? Icons.face : Icons.face_3, color: Colors.white, size: 44),
                      ),
                      const SizedBox(height: 12),
                      Text('C${c.id.replaceAll('C', '')}号', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(c.occupation, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (c.matchScore != null) _buildScoreCard(c),
                  const SizedBox(height: 16),
                  _buildInfoCard(c),
                  const SizedBox(height: 16),
                  _buildHobbiesCard(c),
                  const SizedBox(height: 16),
                  _buildDescCard(c),
                  const SizedBox(height: 16),
                  if (c.matchReasons != null && c.matchReasons!.isNotEmpty) _buildReasonsCard(c),
                  if (c.redFlags.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildRedFlagsCard(c),
                  ],
                  const SizedBox(height: 16),
                  _buildPrivacyCard(context, c),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, c),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(Candidate c) {
    final score = c.matchScore!;
    final color = score >= 8 ? AppTheme.success : (score >= 6 ? AppTheme.warning : AppTheme.error);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 45,
              lineWidth: 8,
              percent: (score / 10).clamp(0, 1),
              center: Text('${score.toStringAsFixed(1)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              progressColor: color,
              backgroundColor: color.withOpacity(0.15),
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('综合匹配度', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(_getScoreDesc(score), style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(height: 8),
                  _buildScoreBar(score),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBar(double score) {
    final descs = ['年龄','学历','地域','职业','性格','爱好'];
    final values = [0.9, 0.85, 1.0, 0.75, 0.8, 0.7];
    return Column(
      children: descs.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(width: 36, child: Text(e.value, style: const TextStyle(fontSize: 11))),
            Expanded(
              child: LinearProgressIndicator(
                value: (values[e.key] * score / 10).clamp(0, 1),
                backgroundColor: AppTheme.divider,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      )).toList(),
    );
  }

  String _getScoreDesc(double score) {
    if (score >= 9) return '完美匹配！强烈推荐';
    if (score >= 8) return '非常匹配，值得深入了解';
    if (score >= 7) return '较好匹配，可以聊聊看';
    if (score >= 6) return '基本匹配，适合进一步认识';
    return '勉强匹配，请谨慎考虑';
  }

  Widget _buildInfoCard(Candidate c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardTitle('基本信息', Icons.person),
            const SizedBox(height: 12),
            _infoRow('性别', c.gender),
            _infoRow('年龄', '${c.age}岁'),
            _infoRow('身高', '${c.height}cm'),
            _infoRow('学历', c.education),
            _infoRow('所在城市', c.location),
            _infoRow('籍贯', c.hometown),
            _infoRow('职业', c.occupation),
            _infoRow('月收入', c.income),
            _infoRow('房产', c.house),
            _infoRow('车辆', c.car == '无' ? '暂无' : c.car),
            _infoRow('性格', '${c.personality} (${_getMbtiDesc(c.personality)})'),
            _infoRow('家庭', c.family),
            _infoRow('婚史', c.marriageHistory),
          ],
        ),
      ),
    );
  }

  Widget _buildHobbiesCard(Candidate c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardTitle('兴趣爱好', Icons.favorite_border),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: c.hobbies.map((h) => Chip(label: Text(h, style: const TextStyle(fontSize: 13)))).toList(),
            ),
            const SizedBox(height: 16),
            _cardTitle('价值观', Icons.auto_awesome),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: c.values.map((v) => Chip(
                label: Text(v, style: const TextStyle(fontSize: 13)),
                backgroundColor: AppTheme.primary.withOpacity(0.08),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescCard(Candidate c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardTitle('自我介绍', Icons.chat_bubble_outline),
            const SizedBox(height: 12),
            Text(c.selfDescription, style: const TextStyle(fontSize: 14, height: 1.6)),
            const SizedBox(height: 16),
            _cardTitle('理想对象', Icons.psychology),
            const SizedBox(height: 12),
            Text(c.idealType, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonsCard(Candidate c) {
    return Card(
      color: AppTheme.success.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.success, size: 20),
                const SizedBox(width: 8),
                const Text('为什么推荐您？', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            ...c.matchReasons!.map((r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, color: AppTheme.success, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(r, style: const TextStyle(fontSize: 13))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRedFlagsCard(Candidate c) {
    return Card(
      color: AppTheme.error.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: AppTheme.error, size: 20),
                const SizedBox(width: 8),
                const Text('需要注意', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.error)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: c.redFlags.map((r) => Chip(
                label: Text(r, style: const TextStyle(fontSize: 12, color: AppTheme.error)),
                backgroundColor: AppTheme.error.withOpacity(0.08),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 隐私内容：联系方式 / 相册 / 学历证书，各需 100 积分解锁。
  Widget _buildPrivacyCard(BuildContext context, Candidate c) {
    final account = Provider.of<AccountProvider>(context);
    final contactKey = 'contact:${c.id}';
    final photoKey = 'photo:${c.id}';
    final eduKey = 'edu:${c.id}';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardTitle('隐私内容 · 积分解锁', Icons.lock_outline),
            const SizedBox(height: 4),
            const Text('查看联系方式 / 相册 / 学历证书 各需 100 积分',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            _privacyRow(
              context, account, Icons.phone, '联系方式',
              account.hasUnlocked(contactKey), contactKey,
              '查看${c.occupation}联系方式',
              unlockedContent: _contactText(c),
            ),
            const Divider(height: 1),
            _privacyRow(
              context, account, Icons.photo_album, '相册',
              account.hasUnlocked(photoKey), photoKey,
              '查看${c.occupation}相册',
              onUnlocked: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PhotoGalleryScreen(candidate: c)),
              ),
            ),
            const Divider(height: 1),
            _privacyRow(
              context, account, Icons.school, '学历证书',
              account.hasUnlocked(eduKey), eduKey,
              '查看${c.education}学历证书',
              onUnlocked: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EduCertScreen(candidate: c)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _privacyRow(
    BuildContext context,
    AccountProvider account,
    IconData icon,
    String title,
    bool unlocked,
    String key,
    String reason, {
    String? unlockedContent,
    VoidCallback? onUnlocked,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon,
          color: unlocked ? AppTheme.success : AppTheme.textSecondary),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: unlocked
          ? Text(unlockedContent ?? '已解锁',
              style: const TextStyle(fontSize: 12, color: AppTheme.success))
          : Text('需 ${AppConfig.unlockCostPoints} 积分',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      trailing: unlocked
          ? TextButton(
              onPressed: onUnlocked,
              child: const Text('查看'),
            )
          : ElevatedButton(
              onPressed: () {
                if (account.points >= AppConfig.unlockCostPoints) {
                  if (account.unlock(key, AppConfig.unlockCostPoints, reason)) {
                    if (onUnlocked != null) onUnlocked();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('积分不足，去「积分」页看广告赚取')));
                  Navigator.pushNamed(context, '/points');
                }
              },
              child: Text('解锁 ${AppConfig.unlockCostPoints}'),
            ),
      onTap: unlocked ? onUnlocked : null,
    );
  }

  String _contactText(Candidate c) {
    final num = c.id.replaceAll(RegExp(r'\D'), '');
    return '微信: C${num}_love  ·  手机: 138****${num.padLeft(4, '0')}';
  }

  Widget _buildActionButtons(BuildContext context, Candidate c) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('返回'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<CandidatesProvider>(context, listen: false)
                      .likeCandidate(c);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('已收藏！可在「我的收藏」中查看'),
                        duration: Duration(seconds: 2)),
                  );
                },
                icon: const Icon(Icons.favorite),
                label: const Text('收藏'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, '/chat', arguments: c),
            icon: const Icon(Icons.chat),
            label: const Text('发消息'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/gifts'),
            icon: const Icon(Icons.card_giftcard),
            label: const Text('送礼物'),
          ),
        ),
      ],
    );
  }

  Widget _cardTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  static String _getMbtiDesc(String mbti) {
    const map = {
      'INTJ': '策划者', 'INTP': '思考者', 'ENTJ': '指挥官', 'ENTP': '辩论家',
      'INFJ': '倡导者', 'INFP': '理想主义者', 'ENFJ': '领导者', 'ENFP': '奋斗者',
      'ISTJ': '检查者', 'ISFJ': '保护者', 'ESTJ': '监督者', 'ESFJ': '供给者',
      'ISTP': '巧匠', 'ISFP': '探险家', 'ESTP': '企业家', 'ESFP': '表演者',
    };
    return map[mbti] ?? mbti;
  }
}
