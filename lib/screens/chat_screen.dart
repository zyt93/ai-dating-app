import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/candidate.dart';
import '../models/chat_message.dart';
import '../providers/chat_provider.dart';
import '../providers/account_provider.dart';
import '../services/profanity_filter.dart';
import '../services/gift_service.dart';
import '../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(Candidate c) {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    if (ProfanityFilter.containsProfanity(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('包含不文明用语，已拦截（${ProfanityFilter.mask(text)}）'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }
    Provider.of<ChatProvider>(context, listen: false).send(c, text);
    _ctrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  void _openGifts(Candidate c) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _GiftSheet(candidate: c),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Candidate c = ModalRoute.of(context)!.settings.arguments as Candidate;
    final chat = Provider.of<ChatProvider>(context);
    final msgs = chat.messagesFor(c.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('C${c.id.replaceAll('C', '')}号'),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () => _openGifts(c),
            tooltip: '送礼物',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: msgs.length,
              itemBuilder: (_, i) => _Bubble(msg: msgs[i]),
            ),
          ),
          _inputBar(c),
        ],
      ),
    );
  }

  Widget _inputBar(Candidate c) => Container(
        padding: EdgeInsets.fromLTRB(
            12, 8, 12, 8 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  hintText: '说点什么…（文明交友）',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _send(c),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: AppTheme.primary),
              onPressed: () => _send(c),
            ),
          ],
        ),
      );
}

class _Bubble extends StatelessWidget {
  final ChatMessage msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isMe = msg.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
          ],
        ),
        child: msg.giftEmoji != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg.text,
                      style: TextStyle(
                          color: isMe ? Colors.white : AppTheme.textPrimary,
                          fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('${msg.giftEmoji} ${msg.giftName ?? ''}',
                      style: const TextStyle(fontSize: 22)),
                ],
              )
            : Text(msg.text,
                style: TextStyle(
                    color: isMe ? Colors.white : AppTheme.textPrimary,
                    fontSize: 14)),
      ),
    );
  }
}

class _GiftSheet extends StatelessWidget {
  final Candidate candidate;
  const _GiftSheet({required this.candidate});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context);
    final chat = Provider.of<ChatProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('赠送礼物',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: GiftService.catalog.map((g) {
              final owned = account.gifts[g.id] ?? 0;
              return GestureDetector(
                onTap: () {
                  if (owned > 0) {
                    account.sendGiftFromBag(g);
                    chat.sendGift(candidate, g);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('背包里没有该礼物，请先去「礼物」页购买')));
                  }
                },
                child: Container(
                  width: 72,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Column(
                    children: [
                      Text(g.emoji, style: const TextStyle(fontSize: 26)),
                      Text(g.name, style: const TextStyle(fontSize: 12)),
                      Text('背包×$owned',
                          style: const TextStyle(
                              fontSize: 10, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('提示：礼物需先在「礼物」页用积分购买后，才能在此赠送。',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
