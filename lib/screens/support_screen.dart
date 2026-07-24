import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_support.dart';
import '../services/profanity_filter.dart';
import '../theme/app_theme.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final List<_Qa> _list = [];

  @override
  void initState() {
    super.initState();
    _list.add(_Qa('AI 客服',
        '您好！我是 AI 客服助手，可解答积分/广告/充值/礼物/定位/隐私等问题，请问有什么可以帮您？', false));
  }

  void _ask() {
    final q = _ctrl.text.trim();
    if (q.isEmpty) return;
    if (ProfanityFilter.containsProfanity(q)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('包含不文明用语，已拦截'),
        backgroundColor: AppTheme.error,
      ));
      return;
    }
    setState(() => _list.add(_Qa('我', q, true)));
    final a = AISupport.answer(q);
    Future.delayed(const Duration(milliseconds: 400),
        () => setState(() => _list.add(_Qa('AI 客服', a, false))));
    _ctrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 客服')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _list.length,
              itemBuilder: (_, i) => _Bubble(qa: _list[i]),
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() => Container(
        padding: EdgeInsets.fromLTRB(
            12, 8, 12, 8 + MediaQuery.of(context).padding.bottom),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  hintText: '输入您的问题…',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _ask(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppTheme.primary),
              onPressed: _ask,
            ),
          ],
        ),
      );
}

class _Qa {
  final String who;
  final String text;
  final bool isMe;
  _Qa(this.who, this.text, this.isMe);
}

class _Bubble extends StatelessWidget {
  final _Qa qa;
  const _Bubble({required this.qa});

  @override
  Widget build(BuildContext context) {
    final isMe = qa.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(qa.text,
            style: TextStyle(
                color: isMe ? Colors.white : AppTheme.textPrimary,
                fontSize: 14)),
      ),
    );
  }
}
