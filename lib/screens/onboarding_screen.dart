import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.psychology,
      'color': AppTheme.primary,
      'title': 'AI 智能匹配',
      'subtitle': '基于多维度画像，精准筛选符合条件的相亲对象',
      'desc': '年龄 · 学历 · 地域 · 性格 · 爱好 · 价值观',
    },
    {
      'icon': Icons.speed,
      'color': AppTheme.secondary,
      'title': '高效筛选',
      'subtitle': '一句话描述你的理想对象，AI 立刻为你匹配',
      'desc': '告别海量浏览，直达最合适的选择',
    },
    {
      'icon': Icons.privacy_tip,
      'color': const Color(0xFF7B1FA2),
      'title': '隐私优先',
      'subtitle': '所有信息脱敏处理，保护你的个人隐私',
      'desc': '候选者信息匿名化，推荐逻辑透明可解释',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, i) => _buildPage(_pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) =>
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage ? AppTheme.primary : AppTheme.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_currentPage == _pages.length - 1)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/profile-setup'),
                        child: const Text('开始设置我的画像'),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/profile-setup'),
                            child: const Text('跳过'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 400), curve: Curves.easeInOut,
                            ),
                            child: const Text('下一步'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 0),
      child: Column(
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: (page['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(page['icon'], color: page['color'] as Color, size: 56),
          ),
          const SizedBox(height: 48),
          Text(page['title'] as String, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(page['subtitle'] as String, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          Text(page['desc'] as String, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
