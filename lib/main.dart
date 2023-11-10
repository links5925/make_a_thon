// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safety/log.dart';
import 'firebase_options.dart';
import 'qr.dart';
import 'running.dart';

void main() async {
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/QR': (context) => QR(),
        '/running': (context) => running(),
        '/info': (context) => log()
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
  dynamic test_data = '데이터 수신 전';

  void readData() {
    final userCollectionReference =
        FirebaseFirestore.instance.collection("users").doc("user1");
    userCollectionReference.get().then((value) => {
          setState(() {
            test_data = value.data(); //type = Map<String, dynamic>
            // test_data = test_data.runtimeType;
          }),
          print(value.data())
        });
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
                Text('$test_data'),
                ElevatedButton(
                    onPressed: readData, child: const Text('데이터 가져오기')),
                Container(height: 30),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/QR');
                    },
                    child: Text('QR'))
              ]),
        ],
      ),
    );
  }
}
