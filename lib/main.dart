// ignore_for_file: non_constant_identifier_names

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safety/log.dart';
import 'firebase_options.dart';
import 'qr.dart';
import 'running.dart';
import 'camera.dart';
import 'ai.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/QR_start': (context) => QR_start(),
        '/QR_end': (context) => QR_end(),
        '/running': (context) => running(),
        '/info': (context) => log(),
        '/real_camera': (context) => real_camera(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  dynamic a = '';
  Future<void> get_data() async {
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("users").doc("user1");
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();
      setState(() {
        a = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('기록 조회'),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/info');
                    },
                    child: Text('정보')),
                Container(height: 30),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/QR_start');
                    },
                    child: Text('QR')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/a');
                      // get_data();
                    },
                    child: Text('test')),
                Text('$a')
              ]),
        ],
      ),
    );
  }
}
