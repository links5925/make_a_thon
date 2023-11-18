// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safety/end.dart';
import 'package:safety/log.dart';
import 'package:safety/userpage.dart';
import 'firebase_options.dart';
import 'qr.dart';
import 'running.dart';

Future<void> main() async {
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
        debugShowCheckedModeBanner: false,
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
        '/end': (context) => endPage(),
        '/user':(context) => userPage()
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
        a = data[''];
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double p = 0.9;
    String rank = '등급';
    int plus = 0;
    int minus = 0;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        actions: [
          SizedBox(width: 10),
          Image.asset(
            'assets/logo.png',
            width: 100,
            height: 100,
          ),
          Spacer(),
          IconButton.outlined(
              onPressed: () {
                Navigator.pushNamed(context, '/info');
              },
              icon: Icon(
                Icons.person,
                size: 35,
                color: Colors.black.withOpacity(0.9),
              )),
          Text('  ')
        ],
      ),
      body: Column(children: [
        SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(15)),
          height: 200,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Rank: ${rank}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.transparent),
                    height: 62,
                    width: 62,
                    child: Image.asset(
                      'assets/r1.png',
                      width: 150,
                      height: 150,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7 * p,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7 * p,
                    height: 10,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(252, 156, 159, 1).withOpacity(0.2),
                              Color.fromRGBO(252, 156, 159, 1).withOpacity(0.8)
                            ]),
                        borderRadius: BorderRadius.circular(90)),
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('PITCH: ${plus}point',
                      style: TextStyle(color: Colors.black.withOpacity(0.8))),
                  ],
              )
            ],
          ),
        ),

        Container(height: 30),
        Align(alignment: Alignment.center,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  shadowColor: MaterialStateProperty.all(Colors.transparent)),
              onPressed: () {
                Navigator.pushNamed(context, '/info');
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        offset: const Offset(5, 7),
                      )
                    ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    width: 200,
                    height: 200,
                    alignment: Alignment.centerLeft,
                    child: Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '이용내역',
                          style: TextStyle(
                              fontSize: 20, color: Colors.black.withOpacity(0.85)),
                        ),
                        Text('이용내역 설명',style: TextStyle(color: Colors.grey[400]),),
                        SizedBox(height: 8),
                      ],
                    )),
                  ),
                  SizedBox(width: 30),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        offset: const Offset(5, 7),
                      )
                    ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    width: 200,
                    height: 200,
                    alignment: Alignment.centerLeft,
                    child: Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '대여하기',
                          style: TextStyle(
                              fontSize: 20, color: Colors.black.withOpacity(0.85)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'QR찍고 시작하기',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            'assets/ve.png',
                            width: 65,
                          ),
                        )
                      ],
                    )),
                  ),
                ],
              )),
        ),
        SizedBox(height: 70),
        Container(
          width: 300,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info),
                      SizedBox(width: 5),
                      Text('PITCH 가이드')
                    ],
                  ),
                  SizedBox(height: 3),
                  Text('이용방법에 대해 알려드려요!')
                ],
              ),
              Spacer(),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                size: 45,
              )
            ],
          ),
        )
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, '/end');
        //       // get_data();
        //     },
        //     child: Text('test')),
      ]),
    );
  }
}
