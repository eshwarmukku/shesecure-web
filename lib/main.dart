import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/safe_places_screen.dart';
import 'screens/emergency_contacts_screen.dart';
import 'screens/voice_detection_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/emergency_alert_screen.dart';
import 'screens/privacy_security_screen.dart';
import 'screens/help_support_screen.dart';

void main() {
  runApp(const SheSecureApp());
}

class SheSecureApp extends StatelessWidget {
  const SheSecureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SheSecure',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),

        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/safe-route': (context) =>
            const Scaffold(body: Center(child: Text("Safe Route Screen"))),
        '/safe-places': (context) => const SafePlacesScreen(),
        '/voice-detection': (context) => const VoiceDetectionScreen(),
        '/contacts': (context) => const EmergencyContactsScreen(),
        '/history': (context) =>
            const Scaffold(body: Center(child: Text("History Screen"))),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
        '/emergency-alert': (context) => const EmergencyAlertScreen(),
        '/privacy-security': (context) => const PrivacySecurityScreen(),
        '/help-support': (context) => const HelpSupportScreen(),
      },
    );
  }
}
