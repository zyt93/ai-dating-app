import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../providers/candidates_provider.dart';
import '../providers/account_provider.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';
import '../models/candidate.dart';

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});
  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _done = false;
  List<Candidate> _matches = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _animController.forward();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
    final candidatesProvider = Provider.of<CandidatesProvider>(context, listen: false);
    final account = Provider.of<AccountProvider>(context, listen: false);
    await candidatesProvider.loadCandidates();
    candidatesProvider.matchCandidates(profile);
    setState(() {
      _matches = candidatesProvider.matchedCandidates
          .where((c) => LocationService.matches(
              c.location, account.regionScope, account.currentRegion))
          .toList();
      _done = true;
    });
  }

  @override
  void dispose() { _animController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 匹配结果'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: !_done
          ? _buildLoading()
          : _matches.isEmpty
              ? _buildEmpty()
              : Column(
                  children: [
                    _buildFilterBar(),
                    Expanded(child: _buildSwipeCards()),
                  ],
                ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animController,
            builder: (_, __) => Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(Icons.favorite, color: AppTheme.primary, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('AI 正在为您分析...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('综合年龄、学历、地域、爱好等多维度筛选',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
          const SizedBox(height: 32),
          const SizedBox(width: 200, child: LinearProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: AppTheme.divider),
            const SizedBox(height: 24),
            const Text('暂未找到完全匹配的对象', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text('试试放宽一些条件，比如扩大年龄范围或城市选择',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/profile-setup'),
              child: const Text('调整我的偏好'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeCards() {
    if (_currentIndex >= _matches.length) {
      return _buildAllSeen();
    }
    final current = _matches[_currentIndex];
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _SwipeCard(candidate: current),
          ),
        ),
        _buildActionBar(current),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
      ],
    );
  }

  Widget _buildAllSeen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: AppTheme.success),
            const SizedBox(height: 24),
            const Text('今日推荐已全部看完', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Text('共 $_currentIndex 位候选人\n感谢使用 AI 相亲助手',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final account = Provider.of<AccountProvider>(context);
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/region'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: AppTheme.background,
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
            const SizedBox(width: 6),
            Text(
              '范围：${account.regionScope == 'domestic' ? '国内' : '全球'} · ${account.currentRegion}',
              style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
            ),
            const Spacer(),
            const Text('切换', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(Candidate c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionBtn(Icons.refresh, '跳过', AppTheme.textSecondary, () => _swipe(false)),
          _actionBtn(Icons.star, '收藏', AppTheme.warning, () {
            Provider.of<CandidatesProvider>(context, listen: false).likeCandidate(c);
            _swipe(false);
          }),
          _actionBtn(Icons.favorite, '喜欢', AppTheme.primary, () => _swipe(true)),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _swipe(bool like) {
    if (like) {
      Provider.of<CandidatesProvider>(context, listen: false).likeCandidate(_matches[_currentIndex]);
    }
    setState(() => _currentIndex++);
  }
}

class _SwipeCard extends StatelessWidget {
  final Candidate candidate;
  const _SwipeCard({required this.candidate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/candidate-detail', arguments: candidate);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // 头像区域
            Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: candidate.gender == '女'
                      ? [AppTheme.primary, const Color(0xFFC2185B)]
                      : [AppTheme.secondary, const Color(0xFFE64A19)],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            candidate.gender == '女' ? Icons.face : Icons.face_3,
                            color: Colors.white, size: 50,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'C${candidate.id.replaceAll('C', '')}号',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12, right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            candidate.matchScore != null ? '${candidate.matchScore!.toStringAsFixed(1)}分' : '--',
                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 信息区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${candidate.age}岁', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text('${candidate.height}cm', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
                        const SizedBox(width: 8),
                        Text(candidate.education, style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
                        const Spacer(),
                        if (candidate.matchScore != null)
                          _scoreBadge(candidate.matchScore!),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text('${candidate.location} · ${candidate.occupation}',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                        const SizedBox(width: 8),
                        Text('· ${candidate.income}',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6, runSpacing: 6,
                      children: candidate.matchTags.take(6).map((tag) =>
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(tag, style: TextStyle(fontSize: 11, color: AppTheme.primary)),
                        )).toList(),
                    ),
                    if (candidate.matchReasons != null && candidate.matchReasons!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      ...candidate.matchReasons!.take(4).map((r) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, size: 14, color: AppTheme.success),
                            const SizedBox(width: 6),
                            Expanded(child: Text(r, style: const TextStyle(fontSize: 12))),
                          ],
                        ),
                      )),
                    ],
                    const SizedBox(height: 12),
                    Text(candidate.selfDescription,
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
                      maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.touch_app, size: 14, color: AppTheme.primary),
                        const SizedBox(width: 4),
                        Text('点击查看详情 →', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreBadge(double score) {
    final color = score >= 8 ? AppTheme.success : (score >= 6 ? AppTheme.warning : AppTheme.error);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text('匹配度 ${score.toStringAsFixed(1)}',
        style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
    );
  }
}
