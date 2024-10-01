import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../../../commons/ui.commons.dart';
import '../../../services/auth_service.dart';
import '../../../services/database_user.dart';
import 'fill_form.dart';

class AuthForm extends StatefulWidget {
  final Function(bool loading) onValidate;
  const AuthForm({
    Key? key,
    required this.onValidate,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool showSignIn = true;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      emailController.text = '';
      nameController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(showSignIn ? 'Se connecter' : 'Créer un compte',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white)),
        actions: [
          TextButton.icon(
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: Text(showSignIn ? "S'inscrire" : 'Se connecter',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
            onPressed: () => toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ColapSvg(
                  asset: !showSignIn ? "register" : "login",
                  size: 300,
                ),
                FillForm(
                    showSignIn: showSignIn,
                    nameController: nameController,
                    emailController: emailController,
                    passwordController: passwordController),
                const SizedBox(height: 40),
                ColapButton(
                  text: showSignIn ? "Se connecter" : "S'inscrire",
                  onPressed: () async {
                    if (_formKey.currentState?.validate() == true) {
                      await handleSignIn();
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(Buttons.Google, onPressed: (() async => await _auth.signInwithGoogle())),
                const SizedBox(
                  height: 20,
                ),
                SignInButton(Buttons.Facebook, onPressed: (() async => await _auth.signInwithFacebook())),
                const SizedBox(height: 20),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 15.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> handleSignIn() async {
    setState(() => loading = true);
    var password = passwordController.value.text.trimRight();
    var email = emailController.value.text.trimRight();
    var name = nameController.value.text.trimRight();

    final nameTaken = await checkIfUserExist(name.toLowerCase());
    if (nameTaken) {
      showErrorName();
    } else {
      await trySignIn(email, password, name);
    }
  }

  Future<void> trySignIn(String email, String password, String name) async {
    dynamic result = showSignIn
        ? await _auth.signInWithEmailAndPassword(email, password)
        : await _auth.registerWithEmailAndPassword(name, email, password);
    if (result == null) {
      setState(() {
        error = 'Veuillez entrer un e-mail valide';
      });
      widget.onValidate(loading = false);
    }
  }

  void showErrorName() {
    setState(() {
      error = 'Ce pseudo existe déjà, veuillez en choisir un autre.';
    });
    widget.onValidate(loading = false);
  }
}
