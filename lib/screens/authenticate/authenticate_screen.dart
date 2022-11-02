import 'package:colap/screens/authenticate/components/auth_form.dart';
import 'package:flutter/material.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: SizedBox(
                width: 200, height: 200, child: CircularProgressIndicator()))
        : AuthForm(onValidate: ((value) => setState(() => loading = value)));
  }
}
