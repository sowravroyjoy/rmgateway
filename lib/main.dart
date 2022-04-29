import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rmgateway/screens/apply.dart';
import 'package:rmgateway/screens/attendance.dart';
import 'package:rmgateway/screens/create_university.dart';
import 'package:rmgateway/screens/employee_details.dart';
import 'package:rmgateway/screens/signin.dart';
import 'package:rmgateway/screens/signup.dart';
import 'package:rmgateway/screens/update_university.dart';
import 'package:rmgateway/screens/update_user.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDufMH7c7Pmm60LEhG0Hj-sTcTBBJnw5p8",
        authDomain: "rmgateway-192e9.firebaseapp.com",
        projectId: "rmgateway-192e9",
        storageBucket: "rmgateway-192e9.appspot.com",
        messagingSenderId: "837585410339",
        appId: "1:837585410339:web:3c920c6d4d0f689d98d496",
        measurementId: "G-6LWLJGK1TS"
    ),
  );
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SignIn(),
    );
  }
}
