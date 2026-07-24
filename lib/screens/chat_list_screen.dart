import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/candidates_provider.dart';
import '../theme/app_theme.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    final candidates = Provider.of<CandidatesProvider>(context, listen: false);
    if (candidates.allCandidates.isEmpty) {
      candidates.loadCandidates();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatProvider>(context);
    final candidates = Provider.of<CandidatesProvider>(context).allCandidates;
    final conversations = chat.conversations;
    return Scaffold(
      appBar: AppBar(title: const Text('消息')),
      body: candidates.isEmpty
          ? const Center(
              child: Text('暂无候选人',
                  style: TextStyle(color: AppTheme.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: candidates.length,
              itemBuilder: (_, i) {
                final c = candidates[i];
                final conv = conversations.where((x) => x.id == c.id).isEmpty
                    ? null
                    : conversations.firstWhere((x) => x.id == c.id);
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      child: Icon(
                          c.gender == '女' ? Icons.face : Icons.face_3,
                          color: AppTheme.primary),
                    ),
                    title: Text('C${c.id.replaceAll('C', '')}号 · ${c.occupation}'),
                    subtitle: Text(
                        conv?.lastMessage ?? '点击开始聊天',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    trailing: conv != null && conv.unread > 0
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: AppTheme.error,
                            child: Text('${conv.unread}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: () {
                      chat.ensureConversation(c);
                      chat.markRead(c.id);
                      Navigator.pushNamed(context, '/chat', arguments: c);
                    },
                  ),
                );
              },
            ),
    );
  }
}
