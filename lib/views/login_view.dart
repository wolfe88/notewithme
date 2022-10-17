import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notewithme/constants/routes.dart';
import 'package:notewithme/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController(); // TODO: implement initState
    _password = TextEditingController(); // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 30,
          fontStyle: FontStyle.italic,
          letterSpacing: 3,
        ),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
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
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final user = FirebaseAuth.instance.currentUser;
                        if (user?.emailVerified ?? false) {
                          devtools.log(userCredential.toString());
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              notesRoute, (route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute, (route) => false);
                          showErrorDialog(context,
                              "Your email isn't verified. Please verify here.");
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == "user-not-found") {
                          devtools.log("!user not found");
                          await showErrorDialog(
                            context,
                            "User not found.",
                          );
                        } else if (e.code == "wrong-password") {
                          await showErrorDialog(
                            context,
                            "Wrong password.",
                          );
                          devtools.log("!wrong password");
                        } else {
                          devtools.log(
                              "!firebase exception but idk what? : ${e.code}");
                          await showErrorDialog(
                            context,
                            "Something went wrong.",
                          );
                        }
                      } catch (e) {
                        await showErrorDialog(
                          context,
                          e.toString(),
                        );
                      }
                    }),
                    child: const Text("Login Button"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute, (route) => false);
                    },
                    child: const Text("Not registered yet? Register here!"),
                  )
                ],
              );
            default:
              return const Text("Loading..");
          }
        },
      ),
    );
  }
}
