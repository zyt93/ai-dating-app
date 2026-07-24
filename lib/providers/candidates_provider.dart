import 'package:flutter/foundation.dart';
import '../models/candidate.dart';
import '../services/match_service.dart';

class CandidatesProvider extends ChangeNotifier {
  final MatchService _matchService = MatchService();
  List<Candidate> _allCandidates = [];
  List<Candidate> _matchedCandidates = [];
  List<Candidate> _likedCandidates = [];
  List<Candidate> _passedCandidates = [];
  bool _isLoading = false;

  List<Candidate> get allCandidates => _allCandidates;
  List<Candidate> get matchedCandidates => _matchedCandidates;
  List<Candidate> get likedCandidates => _likedCandidates;
  bool get isLoading => _isLoading;

  Future<void> loadCandidates() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allCandidates = await _matchService.loadCandidates();
    } catch (e) {
      _allCandidates = _getSampleCandidates();
    }
    _isLoading = false;
    notifyListeners();
  }

  void matchCandidates(dynamic profile) {
    _matchedCandidates = _matchService.match(profile, _allCandidates);
    notifyListeners();
  }

  void likeCandidate(Candidate c) {
    if (!_likedCandidates.any((x) => x.id == c.id)) {
      _likedCandidates.add(c);
      notifyListeners();
    }
  }

  void passCandidate(Candidate c) {
    _passedCandidates.add(c);
    notifyListeners();
  }

  List<Candidate> _getSampleCandidates() {
    // 内置备用候选库（JSON解析失败时使用）
    return [
      Candidate(id:'C001', gender:'女', age:28, height:165, education:'硕士', location:'上海', hometown:'江苏南京',
        occupation:'互联网产品经理', income:'25-30K', house:'无（计划购房）', car:'无', personality:'INTJ',
        hobbies:['旅行','健身','阅读','烘焙'], values:['独立自主','追求成长','工作生活平衡'],
        family:'双亲，独生女，父母退休', marriageHistory:'未婚', children:'无', redFlags:[],
        matchTags:['互联网','INTJ','爱旅行','爱健身','独立','硕士'],
        selfDescription:'喜欢探索新事物，工作认真，生活自律。希望对方有上进心，沟通顺畅。',
        idealType:'28-35岁，本科以上，有责任心，喜欢旅行，地域不限。'),
      Candidate(id:'C002', gender:'女', age:26, height:160, education:'本科', location:'成都', hometown:'四川成都',
        occupation:'小学教师', income:'10-12K', house:'与父母同住', car:'无', personality:'ENFJ',
        hobbies:['唱歌','摄影','撸猫','美食'], values:['家庭为重','喜欢小孩','乐观积极'],
        family:'双亲，独生女，父母退休教师', marriageHistory:'未婚', children:'无', redFlags:[],
        matchTags:['教师','ENFJ','爱猫','顾家','成都'],
        selfDescription:'热爱生活，喜欢小动物，性格温暖。希望未来老公顾家、喜欢小朋友。',
        idealType:'26-33岁，学历相当，有责任心，接受在成都定居。'),
      Candidate(id:'C003', gender:'女', age:29, height:170, education:'硕士', location:'武汉', hometown:'湖北武汉',
        occupation:'律师', income:'30-40K', house:'有（武汉小户型70㎡）', car:'有（电动车）', personality:'ENTJ',
        hobbies:['健身','辩论','高尔夫','红酒'], values:['独立自主','追求卓越','理性决策'],
        family:'双亲，有一哥哥已婚，父母经商', marriageHistory:'未婚', children:'无', redFlags:[],
        matchTags:['律师','ENTJ','高收入','硕士','武汉','健身'],
        selfDescription:'工作狂，但也会享受生活。希望对方同样优秀，能平等对话，不小男人。',
        idealType:'28-38岁，学历相当，有事业心，不娇气，地域不限。'),
      Candidate(id:'C004', gender:'女', age:27, height:162, education:'本科', location:'广州', hometown:'广东佛山',
        occupation:'护士', income:'12-15K', house:'与父母同住', car:'无', personality:'ISFJ',
        hobbies:['烹饪','追剧','养多肉','瑜伽'], values:['温柔贤惠','家庭优先','脚踏实地'],
        family:'双亲，独生女，父母退休', marriageHistory:'未婚', children:'无', redFlags:[],
        matchTags:['护士','ISFJ','顾家','广州','烹饪'],
        selfDescription:'普通女生，喜欢做饭养花，居家型。希望老公顾家，不求大富大贵，只求安稳幸福。',
        idealType:'27-35岁，有正当职业，人品好，不烟不酒，在广州或佛山定居。'),
      Candidate(id:'C005', gender:'女', age:30, height:168, education:'本科', location:'北京', hometown:'山东济南',
        occupation:'品牌策划', income:'18-22K', house:'租房', car:'无', personality:'ESFP',
        hobbies:['跳舞','旅行','演唱会','探店'], values:['有趣第一','活在当下','注重仪式感'],
        family:'单亲（母亲），有一弟弟（已工作）', marriageHistory:'未婚', children:'无', redFlags:['单亲家庭'],
        matchTags:['策划','ESFP','活泼','爱玩','北京'],
        selfDescription:'生活多彩，不甘无聊。希望对方会玩、能聊、不宅，一起创造美好回忆。',
        idealType:'27-35岁，阳光开朗，舍得陪伴，不妈宝，地域不限。'),
    ];
  }
}
