import '../models/gift.dart';

/// 礼物目录。costPoints=用积分购买；redeemPoints=兑换回积分（略低于成本，形成差价）。
class GiftService {
  static const List<Gift> catalog = [
    Gift(id: 'g_heart', name: '爱心', emoji: '💖', costPoints: 30, redeemPoints: 20, description: '小心意'),
    Gift(id: 'g_rose', name: '红玫瑰', emoji: '🌹', costPoints: 50, redeemPoints: 30, description: '经典表白'),
    Gift(id: 'g_choco', name: '巧克力', emoji: '🍫', costPoints: 80, redeemPoints: 50, description: '甜甜蜜蜜'),
    Gift(id: 'g_perfume', name: '香水', emoji: '🧴', costPoints: 200, redeemPoints: 140, description: '精致礼物'),
    Gift(id: 'g_box', name: '礼物盒', emoji: '🎁', costPoints: 120, redeemPoints: 80, description: '惊喜满满'),
    Gift(id: 'g_ring', name: '钻戒', emoji: '💍', costPoints: 500, redeemPoints: 350, description: '求婚神器'),
  ];
}
