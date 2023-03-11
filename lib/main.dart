import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meal_planner/style_fragments.dart';
import 'package:meal_planner/authentication/main_view.dart';
import 'register_web_webview_stub.dart'
if (dart.library.html) 'register_web_webview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBgjQwjE0JcFnxFWNuqtFm0L9m_ZN6PRCM",
        authDomain: "meal-planner-app-f91ae.firebaseapp.com",
        projectId: "meal-planner-app-f91ae",
        storageBucket: "meal-planner-app-f91ae.appspot.com",
        messagingSenderId: "659295288897",
        appId: "1:659295288897:web:99ced1544cd8e043c4d0c0")
  );
  registerWebViewWebImplementation();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          backgroundColor: backgroundColour,
          primaryColor: Colors.orange,
          textTheme: TextTheme(
            bodyText2: GoogleFonts.montserrat(
              color: Colors.black54
            )
          )
        ),
        home:  const MainView(),
    );
  }
}
