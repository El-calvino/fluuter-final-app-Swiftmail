
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/compose_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SwiftMailApp());
}

class SwiftMailApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SwiftMail',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/inbox': (context) => InboxScreen(),
        '/compose': (context) => ComposeScreen(onSend: () {}),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
