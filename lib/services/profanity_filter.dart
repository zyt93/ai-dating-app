/// 不文明词过滤。内置示例词库，覆盖常见中英文侮辱/不文明用语。
/// 生产环境应替换为微信/抖音等平台官方合规词库，并支持云端热更新。
class ProfanityFilter {
  static const List<String> _words = <String>[
    '傻逼', '傻x', '沙比', '沙雕', '煞笔', '废物', '垃圾', '滚蛋', '去死', '贱人',
    '婊子', '操你', '草你', '你妈', '尼玛', '他妈', '妈的', '混蛋', '王八蛋',
    '白痴', '笨蛋', '蠢货', '猪头', '弱智', '脑残', '智障', '闭嘴', '贱', '骚',
    '荡妇', '婊', '鸡巴', '屌', '淫', '嫖', '赌', '抽你', '打你', '弄死你',
    '去你', '卧槽', '我艹', '我靠', '叼', 'shit', 'fuck', 'bitch', 'idiot', 'stupid',
  ];

  static bool containsProfanity(String text) {
    final t = text.toLowerCase();
    return _words.any((w) => t.contains(w.toLowerCase()));
  }

  static String mask(String text) {
    var result = text;
    for (final w in _words) {
      if (result.toLowerCase().contains(w.toLowerCase())) {
        result = result.replaceAll(RegExp(w, caseSensitive: false), '*' * w.length);
      }
    }
    return result;
  }
}
