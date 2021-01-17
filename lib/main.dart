import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  ThemeData theme = ThemeData.dark();
  changeTheme() {
    setState(() {
      if (theme == ThemeData.light())
        theme = ThemeData.dark();
      else
        theme = ThemeData.light();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: theme,
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error ${snapshot.error.toString()}");
            return Text("ERROR");
          } else if (snapshot.hasData) {
            return Home(changeTheme);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
