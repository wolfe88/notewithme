import 'package:flutter/material.dart';
import 'package:notewithme/constants/routes.dart';
import 'package:notewithme/services/auth/auth_exceptions.dart';
import 'package:notewithme/services/auth/auth_service.dart';
import 'package:notewithme/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.italic,
          letterSpacing: 3,
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              hintText: "something@some.thing",
            ),
            // obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              hintText: "Very secret password here",
            ),
          ),
          TextButton(
            onPressed: (() async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                // final user = AuthService.firebase().currentUser;
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Weak Password",
                );
                devtools.log("!weak password");
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  "Email already in use",
                );
                devtools.log("!email already in use");
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  "Invalid email",
                );
                devtools.log("!invalid email");
              } on GenericAuthException {
                await showErrorDialog(context,
                    "Something bad happened while registering. Sorry :(");
                devtools.log("!Something bad happened in auth");
              }
            }),
            child: const Text("Register Button"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text("Already registered? Login here!"))
        ],
      ),
    );
  }
}
