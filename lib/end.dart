import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class endPage extends StatefulWidget {
  const endPage({super.key});

  @override
  State<endPage> createState() => _endPageState();
}

class _endPageState extends State<endPage> {
  String tear = '';
  int plus = 0;
  int minus = 0;
  bool show_plus = false;
  bool show_minus = false;
  List<Widget> plus_data = [];
  List<Widget> minus_data = [];
  var Document_id;

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
        .doc(Document_id);
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();
      setState(() {});
    }
  }

  void make_plus_widget(String reason, int point) {
    plus_data.add(Container(
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xFFFFEE92)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '${reason}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.white),
                  ),
                  Text(
                    '${point}점',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  void make_minus_widget(String reason, int point) {
    minus_data.add(Container(
      height: 70,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xFFFF9292)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              '${reason}',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: Colors.white),
                  ),
                  Text(
                    '${point}점',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        // margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text(
              '반납완료',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(20),
              height: 130,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '랭크',
                            style: TextStyle(fontSize: 25),
                          )),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '현재 ${tear == '' ? '티어' : tear} 등급이에요',
                          style: TextStyle(fontSize: 23),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/r1.png',
                      width: 100,
                      height: 100,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(20),
              height: 170,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '상점',
                            style: TextStyle(fontSize: 25),
                          )),
                      SizedBox(height: 10),
                      Text(
                        '이번 주행으로\n ${plus}점을 달성했어요!',
                        style: TextStyle(fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
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
                          style: TextStyle(color: Colors.black),
                        )),
                  )
                ],
              ),
            ),
            show_plus
                ? Container(
                    child: Column(
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
                                  children: plus_data,
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(20),
              height: 170,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '벌점',
                            style: TextStyle(fontSize: 25),
                          )),
                      SizedBox(height: 10),
                      Text(
                        '이번 주행으로\n ${minus}점을 달성했어요!',
                        style: TextStyle(fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (show_minus == true) {
                              show_minus = false;
                            } else {
                              show_minus = true;
                            }
                          });
                        },
                        child: Text(
                          '\n벌점 항목 보기',
                          style: TextStyle(color: Colors.black),
                        )),
                  )
                ],
              ),
            ),
            show_minus
                ? Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: minus_data,
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 50),
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
                        Navigator.pushNamed(context, '/info');
                      },
                      child: Text(
                        '이용 내역 확인하기',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ))),
            ),
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
    );
  }
}
