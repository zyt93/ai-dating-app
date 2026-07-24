import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/chat_message.dart';
import '../models/conversation.dart';
import '../models/candidate.dart';
import '../models/gift.dart';

/// 会话与消息。会话按候选人建立，消息内存 + 本地持久化。
class ChatProvider extends ChangeNotifier {
  final List<Conversation> _conversations = [];
  final Map<String, List<ChatMessage>> _messages = {};

  List<Conversation> get conversations => List.unmodifiable(_conversations);
  List<ChatMessage> messagesFor(String id) =>
      List.unmodifiable(_messages[id] ?? []);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppConfig.chatStoreKey);
    if (data != null) {
      final m = json.decode(data);
      final conv = m['conversations'];
      if (conv != null) {
        _conversations.addAll((conv as List).map((e) => Conversation.fromJson(e)));
      }
      final msgs = m['messages'];
      if (msgs != null) {
        (msgs as Map).forEach((k, v) {
          _messages[k] =
              (v as List).map((e) => ChatMessage.fromJson(e)).toList();
        });
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConfig.chatStoreKey,
      json.encode({
        'conversations': _conversations.map((c) => c.toJson()).toList(),
        'messages': _messages.map((k, v) =>
            MapEntry(k, v.map((m) => m.toJson()).toList())),
      }),
    );
  }

  void ensureConversation(Candidate c) {
    if (_conversations.any((x) => x.id == c.id)) return;
    _conversations.insert(
      0,
      Conversation(
        id: c.id,
        name: 'C${c.id.replaceAll('C', '')}号 · ${c.occupation}',
        lastMessage: '你好，很高兴认识你～',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        unread: 0,
      ),
    );
    _messages[c.id] = [
      ChatMessage(
        id: '${c.id}_seed',
        conversationId: c.id,
        isMe: false,
        text: '嗨～我是${c.occupation}，${c.selfDescription.length > 18 ? c.selfDescription.substring(0, 18) : c.selfDescription}… 你呢？',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
    _save();
    notifyListeners();
  }

  void send(Candidate c, String text) {
    ensureConversation(c);
    _messages[c.id]!.add(
      ChatMessage(
        id: '${c.id}_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: c.id,
        isMe: true,
        text: text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    _updateConv(c.id, text);
    notifyListeners();
    _autoReply(c);
  }

  void sendGift(Candidate c, Gift g) {
    ensureConversation(c);
    _messages[c.id]!.add(
      ChatMessage(
        id: '${c.id}_gift_${DateTime.now().millisecondsSinceEpoch}',
        conversationId: c.id,
        isMe: true,
        text: '送了你一个${g.name}',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        giftEmoji: g.emoji,
        giftName: g.name,
      ),
    );
    _updateConv(c.id, '[礼物]${g.emoji}${g.name}');
    notifyListeners();
  }

  void _updateConv(String id, String last) {
    final i = _conversations.indexWhere((x) => x.id == id);
    if (i >= 0) {
      _conversations[i] = _conversations[i].copyWith(
        lastMessage: last,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  void _autoReply(Candidate c) {
    Future.delayed(const Duration(seconds: 1), () {
      if (!_conversations.any((x) => x.id == c.id)) return;
      final replies = [
        '哈哈，我也是这么觉得的～',
        '听起来不错呀，可以多聊聊。',
        '那你平时喜欢做些什么呢？',
        '嗯嗯，感觉我们挺合得来的。',
        '谢谢你的关注，期待进一步了解你😊',
      ];
      final reply = replies[DateTime.now().second % replies.length];
      _messages[c.id]!.add(
        ChatMessage(
          id: '${c.id}_r_${DateTime.now().millisecondsSinceEpoch}',
          conversationId: c.id,
          isMe: false,
          text: reply,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      _updateConv(c.id, reply);
      _save();
      notifyListeners();
    });
  }

  void markRead(String id) {
    final i = _conversations.indexWhere((x) => x.id == id);
    if (i >= 0 && _conversations[i].unread > 0) {
      _conversations[i] = _conversations[i].copyWith(unread: 0);
      notifyListeners();
    }
  }
}
