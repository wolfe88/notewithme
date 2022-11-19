import 'package:flutter/material.dart';
import 'package:notewithme/constants/routes.dart';
import 'package:notewithme/services/auth/auth_service.dart';
import 'package:notewithme/views/login_view.dart';
import 'package:notewithme/views/notes/new_note_view.dart';
import 'package:notewithme/views/notes/notes_view.dart';
import 'package:notewithme/views/register_view.dart';
import 'package:notewithme/views/verify_email_view.dart';

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
          newNoteRoute: (context) => const NewNoteView(),
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
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified == true) {
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
              return const NotesView();
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
          // return const LoginView();
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
