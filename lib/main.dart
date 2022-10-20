import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notewithme/constants/routes.dart';
import 'package:notewithme/views/login_view.dart';
import 'package:notewithme/views/notes_view.dart';
import 'package:notewithme/views/register_view.dart';
import 'package:notewithme/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
        routes: {
          notesRoute: (context) => const NotesView(),
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
        }),
  );
}

String isVerifiedMsg = "Error";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // appBar: AppBar(
        //   title: const Text("Home"),
        //   centerTitle: true,
        //   titleTextStyle: const TextStyle(
        //     fontSize: 30,
        //     fontStyle: FontStyle.italic,
        //     letterSpacing: 3,
        //   ),
        // ),
        FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified == true) {
                isVerifiedMsg = "Verified";
              } else {
                isVerifiedMsg = "Not verified";
              }
            } else {
              //user is null
              return const LoginView();
            }
            if (isVerifiedMsg == "Verified") {
              // return Text(isVerifiedMsg);
              return NotesView();
              //go in
            } else {
              //gonna add a notifier
              return const LoginView();
            }
            // final emailVerified = user?.emailVerified ??
            //     false; // if user is null emailVerified = false
            // if (emailVerified) {
            //   print("!verified");
            // } else {
            //   print("!not verified");
            //   Future.delayed(
            //     Duration.zero,
            //     (() {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const VerifyEmailView(),
            //         ),
            //       );
            //     }),
            //   );
            // }
            return const LoginView();
          default:
            return const Text("Loading..");
        }
      },
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Total button presses:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
