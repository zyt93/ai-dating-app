/// 全局配置：积分与人民币换算、广告奖励、解锁成本、充值上限。
/// build marker 2026-07-24 feature-complete
class AppConfig {
  // 积分与人民币换算：100 积分 = 0.01 元  =>  1 元 = 10000 积分
  static const int pointsPerYuan = 10000;
  static const int adRewardPoints = 300; // 看一个广告奖励
  static const int unlockCostPoints = 100; // 查看联系方式 / 照片 / 学历证书 各需
  static const double rechargeCapYuan = 100.0; // 用户限量充值总额上限（元）
  static const String accountStoreKey = 'ai_dating_account_v1';
  static const String chatStoreKey = 'ai_dating_chat_v1';
}
