// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safety/bug.dart';
import 'package:safety/end.dart';
import 'package:safety/log.dart';
import 'package:safety/pitch_detail.dart';
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
        '/user': (context) => userPage(),
        '/pitch_detail': (context) => pitch_detail(),
        '/bug': (context) => bug()
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
  int point = 0;
  double p = 0.9;
  String rank = '뉴비';
  String root = 'r1';
  String weather = '';
  String benefit = '';
  int degree = 1000;
  Future<void> get_data() async {
    final DocumentReference w =
        FirebaseFirestore.instance.collection("cal").doc("stable");
    DocumentSnapshot s = await w.get();
    if (s.exists) {
      dynamic d = s.data();
      setState(() {
        degree = d['degree'];
        weather = d['weather'];
      });
    }

    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("users").doc("user1");
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();
      point = data['point'];
      if (5 <= point && point < 10) {
        rank = '새싹';
        p = point / 10;
        root = 'r1';
        benefit = '  씨앗 30개 제공';
      } else if (10 <= point && point < 50) {
        rank = '나뭇잎';
        p = point / 50;
        root = 'r2';
        benefit = '  씨앗 100개 제공';
      } else if (50 <= point && point < 100) {
        rank = '나뭇가지';
        p = point / 100;
        root = 'r3';
        benefit = '  씨앗 1000개 제공';
      } else if (100 <= point && point < 300) {
        rank = '꽃';
        p = point / 300;
        root = 'r4';
        benefit = '  씨앗 2000개, 잠금해제 mini 제공';
      } else if (point >= 300) {
        rank = '복숭아';
        p = 1;
        root = 'r5';
        benefit = '  씨앗 5000개, 잠금해제 MAX 제공';
      } else {
        rank = '뉴비';
        p = point / 5;
        root = 'r0';
      }

      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    get_data();
  }

  @override
  Widget build(BuildContext context) {
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
                Navigator.pushNamed(context, '/user');
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
          height: 180,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rank ',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${rank}',
                            style: TextStyle(
                                color: Color.fromRGBO(252, 156, 159, 1)
                                    .withOpacity(0.95),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                    //Color.fromRGBO(252, 156, 159, 1)
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.transparent),
                    height: 65,
                    width: 65,
                    child: Image.asset(
                      'assets/${root}.png',
                      width: 170,
                      height: 170,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text('나의 PITCH:',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w600)),
                  Text(' ${point}P',
                      style: TextStyle(
                          color: Color.fromRGBO(252, 156, 159, 1),
                          fontWeight: FontWeight.w600))
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
                  Container(
                    width: 15,
                    height: 15,
                    decoration: ShapeDecoration(
                      color: Colors.amber[400],
                      shape: OvalBorder(),
                    ),
                  ),
                  Text(
                    benefit,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
              // SizedBox(height: 20),
            ],
          ),
        ),
        Container(height: 15),
        Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.centerLeft,
          width: MediaQuery.sizeOf(context).width * 0.85,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.6)),
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Row(
                children: [
                  Text('기온: ${degree}℃',
                      style: TextStyle(
                          fontSize: 20, color: Colors.black.withOpacity(0.8))),
                  SizedBox(width: 40),
                  Text(
                    '  날씨: ${weather}',
                    style: TextStyle(
                        fontSize: 20, color: Colors.black.withOpacity(0.8)),
                  ),
                  SizedBox(width: 14),
                  Icon(
                    Icons.sunny,
                    color: Colors.amber[400],
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    // '  즐거운 라이딩 되세요!',
                    ' 빙판길에 미끄러질 위험이 있으니 안전운전 하세요!',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(height: 30),
        Container(
          width: MediaQuery.sizeOf(context).width * 0.85,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        offset: const Offset(5, 7),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: 160,
                height: 160,
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/info');
                        },
                        child: Container()),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '이용내역',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black.withOpacity(0.85)),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '이용내역 조회',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          SizedBox(height: 25),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.view_timeline_outlined,
                              size: 53,
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              Spacer(),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        offset: const Offset(5, 7),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: 160,
                height: 160,
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/QR_start');
                        },
                        child: Container()),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '대여하기',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black.withOpacity(0.85)),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'QR찍고 시작하기',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          SizedBox(height: 25),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.qr_code,
                              size: 50,
                            ),
                          )
                          // Align(
                          //   alignment: Alignment.bottomRight,
                          //   child: Image.asset(
                          //     'assets/ve.png',
                          //     width: 65,
                          //   ),
                          // )
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 70),
        Container(
          // padding: EdgeInsets.only(top: 10,bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  blurRadius: 5.0,
                  offset: const Offset(5, 7),
                )
              ]),
          clipBehavior: Clip.antiAlias,
          width: 330,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.9)),
                shadowColor: MaterialStateProperty.all(Colors.transparent)),
            onPressed: () {
              Navigator.pushNamed(context, '/pitch_detail');
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'PITCH 가이드',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.8)),
                        )
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(
                      '이용방법에 대해 알려드려요!',
                      style: TextStyle(color: Colors.black.withOpacity(0.8)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right_outlined,
                  size: 45,
                  color: Colors.black.withOpacity(0.8),
                )
              ],
            ),
          ),
        ),
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
