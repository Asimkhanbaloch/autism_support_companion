import 'package:autism_support_companion/AccessibilitySettingsScreen.dart';
import 'package:autism_support_companion/communication_screen.dart';
import 'package:autism_support_companion/emotion_regulation_screen.dart';
import 'package:autism_support_companion/more_features_screen.dart';
import 'package:autism_support_companion/profile_screen.dart';
import 'package:autism_support_companion/task_management_screen.dart'; // Import the provider
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Ensure this is imported
import 'package:provider/provider.dart'; // Import provider package
import 'AccessibilityProvider.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'home_screen.dart';
import 'sensory_support_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()), // Add AccessibilityProvider to the providers list
      ],
      child: Consumer<AccessibilityProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Autism Support Companion',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              brightness: provider.highContrast ? Brightness.dark : Brightness.light,
              textTheme: TextTheme(
                bodyMedium: TextStyle(
                  fontSize: provider.fontSize,
                  fontFamily: provider.fontStyle,
                ),
              ),
            ),
            home:  LoginScreen(),
            initialRoute: '/login', // Set initial route to login screen
            routes: {
              '/login': (context) =>  LoginScreen(),
              '/register': (context) =>  RegisterScreen(),
              '/home': (context) =>  HomeScreen(),
              '/sensory-support': (context) => const SensorySupportScreen(),
              '/task-manager': (context) =>  TaskManagerScreen(),
              '/more-features': (context) =>  MoreFeaturesScreen(),
              '/emotional-regulation': (context) =>  EmotionRegulationScreen(),
              '/communication-tools': (context) =>  CommunicationScreen(),
              '/profile': (context) =>  UserProfileScreen(userId: 'selectedUser.id',),
              '/accessibility-settings': (context) =>  AccessibilitySettingsScreen(),
            },
          );
        },
      ),
    );
  }
}