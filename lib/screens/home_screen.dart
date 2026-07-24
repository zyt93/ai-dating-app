import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/candidates_provider.dart';
import '../providers/account_provider.dart';
import '../screens/chat_list_screen.dart';
import '../screens/points_screen.dart';
import '../screens/support_screen.dart';
import '../screens/gifts_screen.dart';
import '../screens/region_screen.dart';
import '../screens/settings_screen.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.favorite,
                  color: AppTheme.primary, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('AI 相亲助手',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _tab,
        children: const [
          _HomeTab(),
          ChatListScreen(),
          PointsScreen(),
          SupportScreen(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.stars), label: '积分'),
          BottomNavigationBarItem(
              icon: Icon(Icons.support_agent), label: '客服'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    final liked = Provider.of<CandidatesProvider>(context).likedCandidates;
    final account = Provider.of<AccountProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopChips(context, account),
          const SizedBox(height: 16),
          _buildWelcomeCard(context, profile),
          const SizedBox(height: 20),
          _buildQuickMatch(context),
          const SizedBox(height: 20),
          _buildStatsRow(context, liked),
          const SizedBox(height: 20),
          _buildFeatureCards(context),
        ],
      ),
    );
  }

  Widget _buildTopChips(BuildContext context, AccountProvider account) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/points'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04), blurRadius: 8)
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: AppTheme.primary, size: 18),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('我的积分',
                          style: TextStyle(
                              fontSize: 11, color: AppTheme.textSecondary)),
                      Text('${account.points}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/region'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04), blurRadius: 8)
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      color: AppTheme.secondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('定位范围',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary)),
                        Text(
                            account.regionScope == 'domestic'
                                ? '国内 · ${account.currentRegion}'
                                : '全球 · ${account.currentRegion}',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context, dynamic profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppTheme.primary, Color(0xFFC2185B)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.favorite,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('欢迎回来！',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    Text(
                        profile.location.isNotEmpty
                            ? '当前定位：${profile.location}'
                            : '设置你的所在城市',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    profile.summary.isNotEmpty
                        ? profile.summary
                        : '还没有设置你的理想对象描述',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMatch(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/matching'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppTheme.secondary, Color(0xFFE64A19)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.bolt, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI 快速匹配',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('基于你的画像，AI 智能筛选最佳对象',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('开始',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, List liked) {
    return Row(
      children: [
        Expanded(child: _statCard('🎯', '今日匹配', '基于偏好')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('❤️', '我的收藏', '${liked.length}人')),
        const SizedBox(width: 12),
        Expanded(child: _statCard('🔥', '活跃度', '高')),
      ],
    );
  }

  Widget _statCard(String emoji, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(title,
              style:
                  TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeatureCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('更多功能',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _featureTile(Icons.person_add, '完善我的画像', '提高匹配精度',
            () => Navigator.pushNamed(context, '/profile-setup')),
        _featureTile(Icons.card_giftcard, '礼物商城', '积分购买 / 兑换礼物',
            () => Navigator.pushNamed(context, '/gifts')),
        _featureTile(Icons.support_agent, 'AI 客服', '积分 / 广告 / 充值答疑',
            () => Navigator.pushNamed(context, '/support')),
        _featureTile(Icons.share, '分享给朋友', '让朋友也试试 AI 相亲', () {}),
        _featureTile(Icons.help_outline, '使用帮助', '了解如何使用', () {}),
      ],
    );
  }

  Widget _featureTile(IconData icon, String title, String subtitle,
      VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _LikesTab extends StatelessWidget {
  const _LikesTab();
  @override
  Widget build(BuildContext context) {
    final liked = Provider.of<CandidatesProvider>(context).likedCandidates;
    if (liked.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: AppTheme.divider),
            const SizedBox(height: 16),
            const Text('还没有收藏',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('在匹配结果中点击 ❤️ 收藏喜欢的内容',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/matching'),
              child: const Text('去匹配'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: liked.length,
      itemBuilder: (context, i) {
        final c = liked[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primary.withOpacity(0.1),
              child: Icon(c.gender == '女' ? Icons.face : Icons.face_3,
                  color: AppTheme.primary),
            ),
            title: Text(
                'C${c.id.replaceAll('C', '')}号 · ${c.age}岁 · ${c.location}'),
            subtitle: Text('${c.occupation} · ${c.education}',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/candidate-detail',
                arguments: c),
          ),
        );
      },
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;
    final account = Provider.of<AccountProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primary.withOpacity(0.1),
            child: const Icon(Icons.person, size: 50, color: AppTheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
              profile.location.isNotEmpty ? profile.location : '未设置城市',
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
              '${profile.age > 0 ? profile.age : "--"}岁 · ${profile.education.isNotEmpty ? profile.education : "--"}',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('积分余额：${account.points}',
                style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 24),
          _profileMenuItem(Icons.stars, '我的积分',
              () => Navigator.pushNamed(context, '/points')),
          _profileMenuItem(Icons.card_giftcard, '礼物商城',
              () => Navigator.pushNamed(context, '/gifts')),
          _profileMenuItem(Icons.location_on, '定位设置',
              () => Navigator.pushNamed(context, '/region')),
          _profileMenuItem(Icons.person, '编辑我的画像',
              () => Navigator.pushNamed(context, '/profile-setup')),
          _profileMenuItem(Icons.favorite, '我的收藏', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const Scaffold(
                        appBar: AppBar(title: Text('我的收藏')),
                        body: _LikesTab())));
          }),
          _profileMenuItem(Icons.help, '帮助与反馈', () {}),
          _profileMenuItem(Icons.info, '关于 AI 相亲助手', () {}),
        ],
      ),
    );
  }

  Widget _profileMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
