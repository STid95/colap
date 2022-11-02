import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_user.dart';
import 'package:colap/screens/authenticate/authenticate_screen.dart';
import 'package:colap/screens/lists/lists_screen.dart';
import 'package:colap/services/auth_service.dart';
import 'package:colap/services/database_list.dart';
import 'package:colap/services/database_name.dart';
import 'package:colap/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  await Firebase.initializeApp();
  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseListService>(create: (_) => DatabaseListService()),
        Provider<DatabaseNameListService>(
            create: (_) => DatabaseNameListService()),
        StreamProvider<ColapUser?>(
            create: (_) => AuthService().user, initialData: null),
      ],
      child: MaterialApp(
        theme: theme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreenWrapper(),
          '/login': (context) => const AuthenticateScreen(),
          '/lists': (context) => const ListsScreen()
        },
      ),
    );
  }
}
