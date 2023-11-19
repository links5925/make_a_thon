import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class endPage extends StatefulWidget {
  const endPage({super.key});

  @override
  State<endPage> createState() => _endPageState();
}

class _endPageState extends State<endPage> {
  int point = 0;
  String rank = '뉴비';
  String root = 'r1';
  int plus = 1;
  String next = '';
  bool show_plus = false;
  List<Widget> plus_data = [];
  bool legal = false;
  double p = 0.9;
  int state = 0;
  int print_point = 0;

  @override
  void initState() {
    super.initState();
    get_bool_data();
  }

  Future<void> get_bool_data() async {
    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection("vehicles")
        .doc("vehicle1")
        .collection("history")
        .doc('stable');
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();
      if (data['safe']) {
        plus += 1;
        setState(() {
          legal = true;
        });
      }
    }

    final DocumentReference dc =
        FirebaseFirestore.instance.collection("users").doc("user1");
    DocumentSnapshot s = await dc.get();
    if (snapshot.exists) {
      dynamic d = s.data();

      point = d['point'];
      if (5 <= point && point < 10) {
        rank = '새싹';
        next = '나뭇잎';
        p = point / 10;
        root = 'r1';
        print_point = 10 - point;
        state = 1;
      } else if (10 <= point && point < 50) {
        rank = '나뭇잎';
        next = '나뭇가지';
        p = point / 50;
        root = 'r2';
        print_point = 50 - point;
        state = 2;
      } else if (50 <= point && point < 100) {
        rank = '나뭇가지';
        next = '꽃';
        p = point / 100;
        root = 'r3';
        print_point = 100 - point;
      } else if (100 <= point && point < 300) {
        rank = '꽃';
        next = '복숭아';
        p = point / 300;
        print_point = 300 - point;
        root = 'r4';
        state = 3;
      } else if (point >= 300) {
        rank = '복숭아';
        p = 1;
        root = 'r5';
        print_point = point;
        state = 4;
      } else {
        rank = '뉴비';
        next = '새싹';
        p = point / 5;
        root = 'r0';
        print_point = 5 - point;
        state = 5;
      }

      setState(() {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          padding:
              EdgeInsets.only(left: MediaQuery.sizeOf(context).width * 0.05),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                '반납완료',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '나의 랭크',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(252, 156, 159, 1)),
                            )),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${rank} 등급',
                            style: TextStyle(fontSize: 23),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(90)),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.6 * p,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(90)),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.6 * p,
                                height: 10,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color.fromRGBO(252, 156, 159, 1)
                                              .withOpacity(0.2),
                                          Color.fromRGBO(252, 156, 159, 1)
                                              .withOpacity(0.8)
                                        ]),
                                    borderRadius: BorderRadius.circular(90)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text('${next} 등급까지 ${print_point}점 남았어요!'),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            'assets/${root}.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'PITCH',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(252, 156, 159, 1)),
                            )),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '이번 주행으로',
                                  style: TextStyle(fontSize: 23),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '+${plus}점',
                                      style: TextStyle(
                                          fontSize: 23,
                                          color:
                                              Color.fromRGBO(252, 156, 159, 1)),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '을 달성했어요!',
                                      style: TextStyle(fontSize: 23),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              children: [
                                SizedBox(height: 16),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        if (show_plus == true) {
                                          show_plus = false;
                                        } else {
                                          show_plus = true;
                                        }
                                      });
                                    },
                                    child: Text(
                                      '\n상점 항목 보기',
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 2),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              show_plus
                  ? Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15)),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color.fromRGBO(
                                                252, 156, 159, 0.6)),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '주차구역준수',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(90),
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      '1P',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Color.fromRGBO(
                                                              252,
                                                              156,
                                                              159,
                                                              1)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      legal
                                          ? Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Color.fromRGBO(
                                                      242, 156, 159, 0.6)),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '곡예운전예방',
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Container(
                                                            width: 40,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            90),
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            '1P',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Color
                                                                    .fromRGBO(
                                                                        252,
                                                                        156,
                                                                        159,
                                                                        1)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container()
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 30),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 156, 159, 0.6),
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                child: Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Text(
                          '홈 화면으로 돌아가기',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ))),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
