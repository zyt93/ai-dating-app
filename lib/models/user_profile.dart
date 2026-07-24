import 'candidate.dart';

class UserProfile {
  final String gender;
  final int age;
  final int height;
  final String education;
  final String location;
  final String occupation;
  final String income;
  final String personality;
  final List<String> hobbies;
  final String marriageHistory;

  // 择偶偏好
  final int preferredAgeMin;
  final int preferredAgeMax;
  final String preferredEducationMin;
  final List<String> preferredLocations;
  final List<String> preferredOccupations;
  final List<String> preferredPersonalities;
  final List<String> preferredHobbies;
  final List<String> redFlags;
  final String summary;

  UserProfile({
    required this.gender,
    required this.age,
    required this.height,
    required this.education,
    required this.location,
    required this.occupation,
    required this.income,
    required this.personality,
    required this.hobbies,
    required this.marriageHistory,
    required this.preferredAgeMin,
    required this.preferredAgeMax,
    required this.preferredEducationMin,
    required this.preferredLocations,
    required this.preferredOccupations,
    required this.preferredPersonalities,
    required this.preferredHobbies,
    required this.redFlags,
    required this.summary,
  });

  factory UserProfile.empty() {
    return UserProfile(
      gender: '',
      age: 0,
      height: 0,
      education: '',
      location: '',
      occupation: '',
      income: '',
      personality: '',
      hobbies: [],
      marriageHistory: '未婚',
      preferredAgeMin: 22,
      preferredAgeMax: 35,
      preferredEducationMin: '本科',
      preferredLocations: [],
      preferredOccupations: [],
      preferredPersonalities: [],
      preferredHobbies: [],
      redFlags: [],
      summary: '',
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      height: json['height'] ?? 0,
      education: json['education'] ?? '',
      location: json['location'] ?? '',
      occupation: json['occupation'] ?? '',
      income: json['income'] ?? '',
      personality: json['personality'] ?? '',
      hobbies: List<String>.from(json['hobbies'] ?? []),
      marriageHistory: json['marriageHistory'] ?? '未婚',
      preferredAgeMin: json['preferredAgeMin'] ?? 22,
      preferredAgeMax: json['preferredAgeMax'] ?? 35,
      preferredEducationMin: json['preferredEducationMin'] ?? '本科',
      preferredLocations: List<String>.from(json['preferredLocations'] ?? []),
      preferredOccupations: List<String>.from(json['preferredOccupations'] ?? []),
      preferredPersonalities: List<String>.from(json['preferredPersonalities'] ?? []),
      preferredHobbies: List<String>.from(json['preferredHobbies'] ?? []),
      redFlags: List<String>.from(json['redFlags'] ?? []),
      summary: json['summary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'education': education,
      'location': location,
      'occupation': occupation,
      'income': income,
      'personality': personality,
      'hobbies': hobbies,
      'marriageHistory': marriageHistory,
      'preferredAgeMin': preferredAgeMin,
      'preferredAgeMax': preferredAgeMax,
      'preferredEducationMin': preferredEducationMin,
      'preferredLocations': preferredLocations,
      'preferredOccupations': preferredOccupations,
      'preferredPersonalities': preferredPersonalities,
      'preferredHobbies': preferredHobbies,
      'redFlags': redFlags,
      'summary': summary,
    };
  }
}
