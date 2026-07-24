class Candidate {
  final String id;
  final String gender;
  final int age;
  final int height;
  final String education;
  final String location;
  final String hometown;
  final String occupation;
  final String income;
  final String house;
  final String car;
  final String personality;
  final List<String> hobbies;
  final List<String> values;
  final String family;
  final String marriageHistory;
  final String children;
  final List<String> redFlags;
  final List<String> matchTags;
  final String selfDescription;
  final String idealType;
  final double? matchScore;
  final List<String>? matchReasons;

  Candidate({
    required this.id,
    required this.gender,
    required this.age,
    required this.height,
    required this.education,
    required this.location,
    required this.hometown,
    required this.occupation,
    required this.income,
    required this.house,
    required this.car,
    required this.personality,
    required this.hobbies,
    required this.values,
    required this.family,
    required this.marriageHistory,
    required this.children,
    required this.redFlags,
    required this.matchTags,
    required this.selfDescription,
    required this.idealType,
    this.matchScore,
    this.matchReasons,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? 0,
      education: json['education'] ?? '',
      location: json['location'] ?? '',
      hometown: json['hometown'] ?? '',
      occupation: json['occupation'] ?? '',
      income: json['income'] ?? '',
      house: json['house'] ?? '',
      car: json['car'] ?? '',
      personality: json['personality'] ?? '',
      hobbies: List<String>.from(json['hobbies'] ?? []),
      values: List<String>.from(json['values'] ?? []),
      family: json['family'] ?? '',
      marriageHistory: json['marriage_history'] ?? '',
      children: json['children'] ?? '',
      redFlags: List<String>.from(json['red_flags'] ?? []),
      matchTags: List<String>.from(json['match_tags'] ?? []),
      selfDescription: json['self_description'] ?? '',
      idealType: json['ideal_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'age': age,
      'height': height,
      'education': education,
      'location': location,
      'hometown': hometown,
      'occupation': occupation,
      'income': income,
      'house': house,
      'car': car,
      'personality': personality,
      'hobbies': hobbies,
      'values': values,
      'family': family,
      'marriage_history': marriageHistory,
      'children': children,
      'red_flags': redFlags,
      'match_tags': matchTags,
      'self_description': selfDescription,
      'ideal_type': idealType,
    };
  }

  Candidate copyWith({
    String? id,
    String? gender,
    int? age,
    int? height,
    String? education,
    String? location,
    String? hometown,
    String? occupation,
    String? income,
    String? house,
    String? car,
    String? personality,
    List<String>? hobbies,
    List<String>? values,
    String? family,
    String? marriageHistory,
    String? children,
    List<String>? redFlags,
    List<String>? matchTags,
    String? selfDescription,
    String? idealType,
    double? matchScore,
    List<String>? matchReasons,
  }) {
    return Candidate(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      height: height ?? this.height,
      education: education ?? this.education,
      location: location ?? this.location,
      hometown: hometown ?? this.hometown,
      occupation: occupation ?? this.occupation,
      income: income ?? this.income,
      house: house ?? this.house,
      car: car ?? this.car,
      personality: personality ?? this.personality,
      hobbies: hobbies ?? this.hobbies,
      values: values ?? this.values,
      family: family ?? this.family,
      marriageHistory: marriageHistory ?? this.marriageHistory,
      children: children ?? this.children,
      redFlags: redFlags ?? this.redFlags,
      matchTags: matchTags ?? this.matchTags,
      selfDescription: selfDescription ?? this.selfDescription,
      idealType: idealType ?? this.idealType,
      matchScore: matchScore ?? this.matchScore,
      matchReasons: matchReasons ?? this.matchReasons,
    );
  }
}
