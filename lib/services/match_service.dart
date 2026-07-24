import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/candidate.dart';
import '../models/user_profile.dart';

class MatchService {
  static final Map<String, int> _eduOrder = {
    '初中': 1, '高中': 2, '中专': 3, '大专': 4,
    '本科': 5, '硕士': 6, '博士': 7,
  };

  /// 加载内置候选库
  Future<List<Candidate>> loadCandidates() async {
    final jsonString = await rootBundle.loadString('assets/data/candidates.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Candidate.fromJson(e)).toList();
  }

  /// 智能匹配核心算法
  List<Candidate> match(UserProfile profile, List<Candidate> candidates) {
    final results = <_ScoredCandidate>[];

    for (final c in candidates) {
      // 性别过滤
      if (c.gender == profile.gender) continue;
      // 婚史红线
      for (final rf in profile.redFlags) {
        if (c.redFlags.any((r) => r.contains(rf)) || c.marriageHistory.contains(rf)) continue;
      }

      double totalScore = 0;
      double totalWeight = 0;
      final reasons = <String>[];

      // 1. 年龄 (权重3)
      double ageScore = 0;
      if (profile.preferredAgeMin <= c.age && c.age <= profile.preferredAgeMax) {
        ageScore = 10;
        reasons.add('年龄匹配 (${c.age}岁)');
      } else if (profile.preferredAgeMin - 3 <= c.age && c.age <= profile.preferredAgeMax + 3) {
        ageScore = 6;
        reasons.add('年龄可接受 (${c.age}岁)');
      }
      if (ageScore > 0) {
        totalScore += ageScore * 3;
        totalWeight += 3;
      }

      // 2. 学历 (权重3)
      double eduScore = 0;
      final userEduLevel = _eduOrder[profile.preferredEducationMin] ?? 5;
      final candEduLevel = _eduOrder[c.education] ?? 4;
      if (candEduLevel >= userEduLevel) {
        eduScore = 10;
        reasons.add('学历达标 (${c.education})');
      } else if (candEduLevel >= userEduLevel - 1) {
        eduScore = 6;
      }
      if (eduScore > 0) {
        totalScore += eduScore * 3;
        totalWeight += 3;
      }

      // 3. 地域 (权重3)
      if (profile.preferredLocations.isEmpty || profile.preferredLocations.contains(c.location)) {
        totalScore += 10 * 3;
        totalWeight += 3;
        reasons.add('在 ${c.location} 工作');
      }

      // 4. 职业 (权重2)
      if (profile.preferredOccupations.isEmpty) {
        totalScore += 7 * 2;
        totalWeight += 2;
      } else if (profile.preferredOccupations.any((o) => c.occupation.contains(o))) {
        totalScore += 10 * 2;
        totalWeight += 2;
        reasons.add('职业匹配 (${c.occupation})');
      } else {
        totalScore += 5 * 2;
        totalWeight += 2;
      }

      // 5. 性格 (权重2)
      if (profile.preferredPersonalities.isEmpty) {
        totalScore += 7 * 2;
        totalWeight += 2;
      } else if (profile.preferredPersonalities.any((p) => c.personality.startsWith(p[0]))) {
        totalScore += 10 * 2;
        totalWeight += 2;
        reasons.add('性格 ${c.personality} (${_getPersonalityDesc(c.personality)})');
      } else {
        totalScore += 5 * 2;
        totalWeight += 2;
      }

      // 6. 爱好 (权重2)
      if (profile.preferredHobbies.isNotEmpty) {
        final matched = c.hobbies.where((h) =>
          profile.preferredHobbies.any((ph) => h.contains(ph) || ph.contains(h))
        ).toList();
        final hobbyScore = matched.isEmpty ? 3 : (matched.length * 3 + 4).clamp(4, 10).toDouble();
        totalScore += hobbyScore * 2;
        totalWeight += 2;
        if (matched.isNotEmpty) reasons.add('共同爱好: ${matched.join(", ")}');
      } else {
        totalScore += 7 * 2;
        totalWeight += 2;
      }

      if (totalWeight == 0) continue;
      final finalScore = totalScore / totalWeight;

      if (finalScore >= 6.0) {
        results.add(_ScoredCandidate(
          candidate: c,
          score: finalScore,
          reasons: reasons,
        ));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results.map((r) => r.candidate.copyWith(
      matchScore: r.score,
      matchReasons: r.reasons,
    )).toList();
  }

  static String _getPersonalityDesc(String mbti) {
    const map = {
      'INTJ': '策划者', 'INTP': '思考者', 'ENTJ': '指挥官', 'ENTP': '辩论家',
      'INFJ': '倡导者', 'INFP': '理想主义者', 'ENFJ': '领导者', 'ENFP': '奋斗者',
      'ISTJ': '检查者', 'ISFJ': '保护者', 'ESTJ': '监督者', 'ESFJ': '供给者',
      'ISTP': '巧匠', 'ISFP': '探险家', 'ESTP': '企业家', 'ESFP': '表演者',
    };
    return map[mbti] ?? mbti;
  }
}

class _ScoredCandidate {
  final Candidate candidate;
  final double score;
  final List<String> reasons;
  _ScoredCandidate({required this.candidate, required this.score, required this.reasons});
}
