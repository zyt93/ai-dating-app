class PointsTransaction {
  final String id;
  final String type; // earn | spend | recharge
  final int amount;
  final String reason;
  final int timestamp;

  PointsTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.reason,
    required this.timestamp,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) => PointsTransaction(
        id: json['id'] ?? '',
        type: json['type'] ?? '',
        amount: json['amount'] ?? 0,
        reason: json['reason'] ?? '',
        timestamp: json['timestamp'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'reason': reason,
        'timestamp': timestamp,
      };
}
