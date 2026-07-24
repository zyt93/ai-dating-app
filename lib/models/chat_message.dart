class ChatMessage {
  final String id;
  final String conversationId;
  final bool isMe;
  final String text;
  final int timestamp;
  final String? giftEmoji;
  final String? giftName;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.isMe,
    required this.text,
    required this.timestamp,
    this.giftEmoji,
    this.giftName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] ?? '',
        conversationId: json['conversationId'] ?? '',
        isMe: json['isMe'] ?? false,
        text: json['text'] ?? '',
        timestamp: json['timestamp'] ?? 0,
        giftEmoji: json['giftEmoji'],
        giftName: json['giftName'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversationId': conversationId,
        'isMe': isMe,
        'text': text,
        'timestamp': timestamp,
        'giftEmoji': giftEmoji,
        'giftName': giftName,
      };
}
