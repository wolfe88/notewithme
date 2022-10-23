import 'package:flutter/material.dart';
import 'package:notewithme/constants/routes.dart';
import 'package:notewithme/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
      ),
      //does not tested*
      body: Column(
        children: [
          const Text(
            "We've send you an email verification. Please open it to verify your account.",
          ),
          const Text(
            "Email doesn't reached to you? Click here for another one.",
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send email verification."),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}
