import 'package:flutter/material.dart';

class FillForm extends StatelessWidget {
  const FillForm({
    Key? key,
    required this.showSignIn,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final bool showSignIn;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!showSignIn)
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Pseudo'),
            validator: (value) =>
                value == null || value.isEmpty ? "Entrez un pseudo" : null,
          ),
        !showSignIn ? const SizedBox(height: 10.0) : Container(),
        TextFormField(
          controller: emailController,
          decoration: const InputDecoration(hintText: 'Email'),
          validator: (value) =>
              value == null || value.isEmpty ? "Entrez un email" : null,
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          controller: passwordController,
          decoration: const InputDecoration(hintText: 'Mot de passe'),
          obscureText: true,
          validator: (value) => value != null && value.length < 6
              ? "Le mot de passe doit être de 6 caractères minimum"
              : null,
        )
      ],
    );
  }
}
