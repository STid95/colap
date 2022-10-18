import 'package:colap/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:colap/models/colap_user.dart';
import 'package:colap/screens/authenticate_screen.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ColapUser?>(context);
    if (user == null) {
      return const AuthenticateScreen();
    } else {
      return const HomeScreen();
    }
  }
}
