import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/points_transaction.dart';
import '../models/gift.dart';

/// 账户中心：积分余额、解锁记录、礼物背包、充值额度、定位范围。
/// 通过 shared_preferences 持久化。
class AccountProvider extends ChangeNotifier {
  int _points = 0;
  double _rechargedYuan = 0;
  final Set<String> _unlocks = {}; // 'contact:C001' / 'photo:C001' / 'edu:C001'
  final Map<String, int> _gifts = {}; // giftId -> 拥有数量
  final List<PointsTransaction> _transactions = [];
  String _regionScope = 'domestic'; // 'domestic' | 'global'
  String _currentRegion = '全国';

  int get points => _points;
  double get rechargedYuan => _rechargedYuan;
  List<PointsTransaction> get transactions => List.unmodifiable(_transactions);
  Set<String> get unlocks => _unlocks;
  Map<String, int> get gifts => Map.unmodifiable(_gifts);
  String get regionScope => _regionScope;
  String get currentRegion => _currentRegion;
  int get rechargedRemainingYuan =>
      ((AppConfig.rechargeCapYuan - _rechargedYuan).ceil());
  bool get canRechargeMore => _rechargedYuan < AppConfig.rechargeCapYuan - 1e-9;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(AppConfig.accountStoreKey);
    if (data != null) {
      final m = json.decode(data);
      _points = m['points'] ?? 0;
      _rechargedYuan = (m['rechargedYuan'] ?? 0).toDouble();
      _regionScope = m['regionScope'] ?? 'domestic';
      _currentRegion = m['currentRegion'] ?? '全国';
      _unlocks.addAll(List<String>.from(m['unlocks'] ?? []));
      final g = m['gifts'];
      if (g != null) (g as Map).forEach((k, v) => _gifts[k] = v);
      final tx = m['transactions'];
      if (tx != null) {
        _transactions.addAll((tx as List).map((e) => PointsTransaction.fromJson(e)));
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppConfig.accountStoreKey,
      json.encode({
        'points': _points,
        'rechargedYuan': _rechargedYuan,
        'regionScope': _regionScope,
        'currentRegion': _currentRegion,
        'unlocks': _unlocks.toList(),
        'gifts': _gifts,
        'transactions': _transactions.map((t) => t.toJson()).toList(),
      }),
    );
  }

  void _addTx(String type, int amount, String reason) {
    _transactions.insert(
      0,
      PointsTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        amount: amount,
        reason: reason,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void earn(int amount, String reason) {
    _points += amount;
    _addTx('earn', amount, reason);
    _save();
    notifyListeners();
  }

  bool spend(int cost, String reason) {
    if (_points < cost) return false;
    _points -= cost;
    _addTx('spend', cost, reason);
    _save();
    notifyListeners();
    return true;
  }

  bool recharge(double yuan) {
    if (_rechargedYuan + yuan > AppConfig.rechargeCapYuan + 1e-9) return false;
    _rechargedYuan += yuan;
    final pts = (yuan * AppConfig.pointsPerYuan).round();
    _points += pts;
    _addTx('recharge', pts, '充值 ¥${yuan.toStringAsFixed(2)}');
    _save();
    notifyListeners();
    return true;
  }

  bool hasUnlocked(String key) => _unlocks.contains(key);

  bool unlock(String key, int cost, String reason) {
    if (_unlocks.contains(key)) return true;
    if (!spend(cost, reason)) return false;
    _unlocks.add(key);
    _save();
    notifyListeners();
    return true;
  }

  /// 购买礼物加入背包（扣除 costPoints）
  bool buyGift(Gift g) {
    if (!spend(g.costPoints, '购买礼物·${g.name}')) return false;
    _gifts[g.id] = (_gifts[g.id] ?? 0) + 1;
    _save();
    notifyListeners();
    return true;
  }

  /// 从背包赠送（免费，仅减库存）
  bool sendGiftFromBag(Gift g) {
    if ((_gifts[g.id] ?? 0) <= 0) return false;
    _gifts[g.id] = _gifts[g.id]! - 1;
    _save();
    notifyListeners();
    return true;
  }

  /// 兑换礼物回积分
  bool redeemGift(Gift g) {
    if ((_gifts[g.id] ?? 0) <= 0) return false;
    _gifts[g.id] = _gifts[g.id]! - 1;
    _points += g.redeemPoints;
    _addTx('earn', g.redeemPoints, '兑换礼物·${g.name}');
    _save();
    notifyListeners();
    return true;
  }

  void setRegion(String scope, String region) {
    _regionScope = scope;
    _currentRegion = region;
    _save();
    notifyListeners();
  }
}
