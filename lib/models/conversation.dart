class Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final int timestamp;
  final int unread;

  Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.unread = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        lastMessage: json['lastMessage'] ?? '',
        timestamp: json['timestamp'] ?? 0,
        unread: json['unread'] ?? 0,
      );

  Conversation copyWith({String? lastMessage, int? timestamp, int? unread}) => Conversation(
        id: id,
        name: name,
        lastMessage: lastMessage ?? this.lastMessage,
        timestamp: timestamp ?? this.timestamp,
        unread: unread ?? this.unread,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'lastMessage': lastMessage,
        'timestamp': timestamp,
        'unread': unread,
      };
}
