class Gift {
  final String id;
  final String name;
  final String emoji;
  final int costPoints; // 用积分购买 / 赠送
  final int redeemPoints; // 兑换回积分
  final String description;

  const Gift({
    required this.id,
    required this.name,
    required this.emoji,
    required this.costPoints,
    required this.redeemPoints,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'costPoints': costPoints,
        'redeemPoints': redeemPoints,
        'description': description,
      };
}
