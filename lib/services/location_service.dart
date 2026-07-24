/// 定位与地区范围。先覆盖国内主要城市，开启全球后纳入海外国家。
class LocationService {
  static const List<String> domesticProvinces = [
    '北京', '上海', '广州', '深圳', '成都', '杭州', '武汉', '南京', '重庆', '西安',
    '苏州', '天津', '长沙', '郑州', '青岛', '厦门', '昆明', '合肥', '宁波', '无锡',
    '佛山', '东莞', '济南', '福州', '沈阳', '大连', '哈尔滨', '长春', '石家庄', '太原',
    '南昌', '南宁', '贵阳', '海口', '兰州', '银川', '西宁', '呼和浩特', '乌鲁木齐', '拉萨',
  ];

  static const List<String> globalCountries = [
    '美国', '日本', '韩国', '英国', '法国', '德国', '加拿大', '澳大利亚', '新加坡',
    '马来西亚', '泰国', '新西兰', '荷兰', '瑞典', '瑞士', '意大利', '西班牙',
  ];

  static List<String> regionsForScope(String scope) {
    if (scope == 'global') {
      return ['全国', ...domesticProvinces, ...globalCountries];
    }
    return ['全国', ...domesticProvinces];
  }

  /// 候选城市是否落入当前范围。
  static bool matches(String candidateLocation, String scope, String currentRegion) {
    if (currentRegion == '全国') {
      return scope == 'domestic' ? _isChina(candidateLocation) : true;
    }
    return candidateLocation.contains(currentRegion);
  }

  static bool _isChina(String loc) => domesticProvinces.any((p) => loc.contains(p));
}
