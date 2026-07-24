import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../models/user_profile.dart';
import '../theme/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();

  // 个人信息
  String _gender = '';
  int _age = 25;
  int _height = 168;
  String _education = '本科';
  String _location = '';
  String _occupation = '';
  String _income = '';
  String _personality = '';

  // 择偶偏好
  int _prefAgeMin = 22;
  int _prefAgeMax = 35;
  String _prefEducationMin = '本科';
  final List<String> _prefLocations = [];
  final List<String> _prefOccupations = [];
  final List<String> _prefHobbies = [];
  final List<String> _redFlags = [];
  String _summary = '';

  final List<String> _educationList = ['初中','高中','中专','大专','本科','硕士','博士'];
  final List<String> _personalityList = ['INTJ','INTP','ENTJ','ENTP','INFJ','INFP','ENFJ','ENFP','ISTJ','ISFJ','ESTJ','ESFJ','ISTP','ISFP','ESTP','ESFP'];
  final List<String> _hobbyList = ['旅行','健身','阅读','美食','音乐','电影','摄影','游戏','烹饪','运动','宠物','艺术'];
  final List<String> _occupationList = ['互联网','金融','医疗','教育','法律','工程','媒体','公务员','国企','外企','自由职业'];
  final List<String> _redFlagList = ['有婚史','有子女','抽烟','酗酒','异地','单亲家庭','宗教极端'];

  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _occupationCtrl = TextEditingController();
  final TextEditingController _incomeCtrl = TextEditingController();

  final int _totalSteps = 3;

  @override
  void dispose() {
    _locationCtrl.dispose();
    _occupationCtrl.dispose();
    _incomeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置我的画像'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            child: const Text('跳过'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildStepContent(),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps, (i) =>
              Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: i < _totalSteps - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppTheme.primary : AppTheme.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ['Step 1: 基本信息', 'Step 2: 择偶偏好', 'Step 3: 生成画像'][_step],
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0: return _buildStep1();
      case 1: return _buildStep2();
      case 2: return _buildStep3();
      default: return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('你的性别'),
        _genderSelector(),
        const SizedBox(height: 24),
        _sectionTitle('年龄'),
        _sliderField('$_age 岁', _age.toDouble(), 18, 55, (v) => setState(() => _age = v.round())),
        const SizedBox(height: 24),
        _sectionTitle('身高'),
        _sliderField('$_height cm', _height.toDouble(), 150, 195, (v) => setState(() => _height = v.round())),
        const SizedBox(height: 24),
        _sectionTitle('学历'),
        _chipSelector(_educationList, _education, (v) => setState(() => _education = v)),
        const SizedBox(height: 24),
        _sectionTitle('所在城市'),
        TextField(
          controller: _locationCtrl,
          decoration: const InputDecoration(hintText: '例如：上海、杭州、深圳'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('职业'),
        TextField(
          controller: _occupationCtrl,
          decoration: const InputDecoration(hintText: '例如：产品经理、设计师'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('月收入范围'),
        TextField(
          controller: _incomeCtrl,
          decoration: const InputDecoration(hintText: '例如：15-20K'),
        ),
        const SizedBox(height: 24),
        _sectionTitle('性格类型（MBTI，可不填）'),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _personalityList.map((p) => FilterChip(
            label: Text(p, style: TextStyle(fontSize: 12)),
            selected: _personality == p,
            onSelected: (s) => setState(() => _personality = s ? p : ''),
          )).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('希望对方年龄范围'),
        Row(
          children: [
            Expanded(child: _sliderField('最小 $_prefAgeMin', _prefAgeMin.toDouble(), 18, 55, (v) => setState(() => _prefAgeMin = v.round()))),
            const SizedBox(width: 16),
            Expanded(child: _sliderField('最大 $_prefAgeMax', _prefAgeMax.toDouble(), 18, 55, (v) => setState(() => _prefAgeMax = v.round()))),
          ],
        ),
        const SizedBox(height: 24),
        _sectionTitle('最低学历要求'),
        _chipSelector(_educationList, _prefEducationMin, (v) => setState(() => _prefEducationMin = v)),
        const SizedBox(height: 24),
        _sectionTitle('希望对方所在城市（可多选）'),
        Wrap(spacing: 8, runSpacing: 8, children: ['北京','上海','广州','深圳','杭州','成都','武汉','南京','西安'].map((c) =>
          FilterChip(label: Text(c), selected: _prefLocations.contains(c),
            onSelected: (s) => setState(() => s ? _prefLocations.add(c) : _prefLocations.remove(c)))).toList()),
        const SizedBox(height: 24),
        _sectionTitle('希望对方职业类型（可多选）'),
        Wrap(spacing: 8, runSpacing: 8, children: _occupationList.map((o) =>
          FilterChip(label: Text(o, style: const TextStyle(fontSize: 12)), selected: _prefOccupations.contains(o),
            onSelected: (s) => setState(() => s ? _prefOccupations.add(o) : _prefOccupations.remove(o)))).toList()),
        const SizedBox(height: 24),
        _sectionTitle('共同爱好加分（可多选）'),
        Wrap(spacing: 8, runSpacing: 8, children: _hobbyList.map((h) =>
          FilterChip(label: Text(h, style: const TextStyle(fontSize: 12)), selected: _prefHobbies.contains(h),
            onSelected: (s) => setState(() => s ? _prefHobbies.add(h) : _prefHobbies.remove(h)))).toList()),
        const SizedBox(height: 24),
        _sectionTitle('绝对红线（不符合即过滤）'),
        Wrap(spacing: 8, runSpacing: 8, children: _redFlagList.map((r) =>
          FilterChip(label: Text(r, style: const TextStyle(fontSize: 12)), selected: _redFlags.contains(r),
            onSelected: (s) => setState(() => s ? _redFlags.add(r) : _redFlags.remove(r)))).toList()),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppTheme.primary, size: 22),
                  const SizedBox(width: 8),
                  const Text('AI 分析结果', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              _buildProfileSummary(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('一句话描述你的理想对象：', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '例如：找一个有上进心、喜欢旅行、能聊得来的人...',
          ),
          onChanged: (v) => _summary = v,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '以上信息将用于为您匹配最合适的对象。点击「完成」即可开始匹配！',
                  style: TextStyle(fontSize: 13, color: Colors.amber.shade900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSummary() {
    return Column(
      children: [
        _summaryRow('年龄', '${_prefAgeMin}-${_prefAgeMax}岁'),
        _summaryRow('学历', '$_prefEducationMin 及以上'),
        if (_prefLocations.isNotEmpty) _summaryRow('城市', _prefLocations.join('、')),
        if (_prefOccupations.isNotEmpty) _summaryRow('职业', _prefOccupations.join('、')),
        if (_prefHobbies.isNotEmpty) _summaryRow('爱好', _prefHobbies.join('、')),
        if (_redFlags.isNotEmpty) _summaryRow('红线', _redFlags.join('、'), isWarning: true),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text('$label：', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                color: isWarning ? AppTheme.error : AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Row(
        children: [
          if (_step > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _step--),
                child: const Text('上一步'),
              ),
            ),
          if (_step > 0) const SizedBox(width: 16),
          Expanded(
            flex: _step == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _onNext,
              child: Text(_step == _totalSteps - 1 ? '完成，开始匹配' : '下一步'),
            ),
          ),
        ],
      ),
    );
  }

  void _onNext() {
    if (_step == 0) {
      _location = _locationCtrl.text.trim();
      _occupation = _occupationCtrl.text.trim();
      _income = _incomeCtrl.text.trim();
      if (_gender.isEmpty) { _showMsg('请选择你的性别'); return; }
      if (_location.isEmpty) { _showMsg('请填写所在城市'); return; }
    }
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      _saveAndMatch();
    }
  }

  Future<void> _saveAndMatch() async {
    final profile = UserProfile(
      gender: _gender,
      age: _age,
      height: _height,
      education: _education,
      location: _location,
      occupation: _occupation,
      income: _income,
      personality: _personality,
      hobbies: [],
      marriageHistory: '未婚',
      preferredAgeMin: _prefAgeMin,
      preferredAgeMax: _prefAgeMax,
      preferredEducationMin: _prefEducationMin,
      preferredLocations: _prefLocations,
      preferredOccupations: _prefOccupations,
      preferredPersonalities: [],
      preferredHobbies: _prefHobbies,
      redFlags: _redFlags,
      summary: _summary,
    );
    Provider.of<ProfileProvider>(context, listen: false).updateProfile(profile);
    await Provider.of<ProfileProvider>(context, listen: false).saveProfile();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/matching');
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
    );
  }

  Widget _genderSelector() {
    return Row(
      children: [
        Expanded(child: _genderOption('男', '🚹')),
        const SizedBox(width: 12),
        Expanded(child: _genderOption('女', '🚺')),
      ],
    );
  }

  Widget _genderOption(String label, String emoji) {
    final isSelected = _gender == label;
    return GestureDetector(
      onTap: () => setState(() => _gender = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.divider, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(
              fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
            )),
          ],
        ),
      ),
    );
  }

  Widget _sliderField(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            Text(label.split(' ')[0], style: TextStyle(fontSize: 14, color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        Slider(
          value: value, min: min, max: max, divisions: (max - min).round(),
          activeColor: AppTheme.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _chipSelector(List<String> options, String selected, ValueChanged<String> onSelected) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: options.map((o) => FilterChip(
        label: Text(o, style: TextStyle(fontSize: 13)),
        selected: selected == o,
        onSelected: (_) => onSelected(o),
      )).toList(),
    );
  }
}
