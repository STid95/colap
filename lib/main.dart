import 'package:colap/models/colap_user.dart';
import 'package:colap/screens/authenticate_screen.dart';
import 'package:colap/screens/lists_screen.dart';
import 'package:colap/services/auth_service.dart';
import 'package:colap/services/database_list.dart';
import 'package:colap/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseListService>(create: (_) => DatabaseListService()),
        StreamProvider<ColapUser?>(
            create: (_) => AuthService().user, initialData: null),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreenWrapper(),
          '/login': (context) => const AuthenticateScreen(),
          '/lists': (context) => const ListsScreen()
        },
      ),
    );
  }
}
