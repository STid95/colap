import 'package:colap/commons/ui.commons.dart';
import 'package:colap/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../services/database_user.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({super.key});

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: SizedBox(
                width: 200, height: 200, child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              title: Text(showSignIn ? 'Se connecter' : 'Créer un compte',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(showSignIn ? "S'inscrire" : 'Se connecter',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white)),
                  onPressed: () => toggleView(),
                ),
              ],
            ),
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ColapSvg(
                      asset: !showSignIn ? "register" : "login",
                      size: 300,
                    ),
                    Column(
                      children: [
                        if (!showSignIn)
                          TextFormField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(hintText: 'Pseudo'),
                            validator: (value) => value == null || value.isEmpty
                                ? "Entrez un pseudo"
                                : null,
                          ),
                        !showSignIn
                            ? const SizedBox(height: 10.0)
                            : Container(),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(hintText: 'Email'),
                          validator: (value) => value == null || value.isEmpty
                              ? "Entrez un email"
                              : null,
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: passwordController,
                          decoration:
                              const InputDecoration(hintText: 'Mot de passe'),
                          obscureText: true,
                          validator: (value) => value != null &&
                                  value.length < 6
                              ? "Le mot de passe doit être de 6 caractères minimum"
                              : null,
                        )
                      ],
                    ),
                    ColapButton(
                      text: showSignIn ? "Se connecter" : "S'inscrire",
                      onPressed: () async {
                        if (_formKey.currentState?.validate() == true) {
                          setState(() => loading = true);
                          var password =
                              passwordController.value.text.trimRight();
                          var email = emailController.value.text.trimRight();
                          var name = nameController.value.text.trimRight();

                          final nameTaken =
                              await checkIfUserExist(name.toLowerCase());
                          if (nameTaken) {
                            setState(() {
                              loading = false;
                              error =
                                  'Ce pseudo existe déjà, veuillez en choisir un autre.';
                            });
                          } else {
                            dynamic result = showSignIn
                                ? await _auth.signInWithEmailAndPassword(
                                    email, password)
                                : await _auth.registerWithEmailAndPassword(
                                    name, email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'Veuillez entrer un e-mail valide';
                              });
                            }
                          }
                        }
                      },
                    ),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
