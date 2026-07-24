import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/candidate.dart';
import 'models/user_profile.dart';
import 'services/match_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/matching_screen.dart';
import 'screens/candidate_detail_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/points_screen.dart';
import 'screens/support_screen.dart';
import 'screens/gifts_screen.dart';
import 'screens/region_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';
import 'providers/profile_provider.dart';
import 'providers/candidates_provider.dart';
import 'providers/account_provider.dart';
import 'providers/chat_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CandidatesProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'AI 相亲助手',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/home': (context) => const HomeScreen(),
          '/profile-setup': (context) => const ProfileSetupScreen(),
          '/matching': (context) => const MatchingScreen(),
          '/candidate-detail': (context) => const CandidateDetailScreen(),
          '/matches': (context) => const MatchesScreen(),
          '/chat': (context) => const ChatScreen(),
          '/chat-list': (context) => const ChatListScreen(),
          '/points': (context) => const PointsScreen(),
          '/support': (context) => const SupportScreen(),
          '/gifts': (context) => const GiftsScreen(),
          '/region': (context) => const RegionScreen(),
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
