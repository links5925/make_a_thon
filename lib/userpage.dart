import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class userPage extends StatefulWidget {
  const userPage({super.key});

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  int point = 0;
  double p = 0.9;
  String rank = '등급';
  String next = '';
  int print_point = 0;
  String name = '이름';
  bool detail = false;
  String root = 'r1';
  int state = 0;

  Future<void> get_data() async {
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("users").doc("user1");
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();

      point = data['point'];
      name = data['name'];
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70),
                Text(
                  '    나의 라이딩 등급',
                  style: TextStyle(
                      fontSize: 25, color: Colors.black.withOpacity(0.8)),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_circle,
                              size: 55,
                              color: Colors.grey[400],
                            ),
                            Text(
                              '  ${name}',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Stack(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(90)),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.8 *
                                      p,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(90)),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.8 *
                                      p,
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
                            )),
                        SizedBox(height: 15),
                        Text(
                          print_point < 300
                              ? '${next} 등급까지 ${print_point}점 남았어요!'
                              : '복숭아등급 ${print_point}입니다!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  '    라이딩 등급 혜택',
                  style: TextStyle(
                      fontSize: 23, color: Colors.black.withOpacity(0.7)),
                ),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 30),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: Colors.transparent),
                            child: Image.asset('assets/${root}.png'),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(252, 156, 159, 1),
                                  borderRadius: BorderRadius.circular(90)),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                252, 156, 159, 1))),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                252, 156, 159, 1))),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                252, 156, 159, 1))),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                252, 156, 159, 1))),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(90),
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                252, 156, 159, 1))),
                                  )
                                ],
                              ),
                            ),
                            state != 0
                                ? Row(
                                    children: [
                                      SizedBox(width: 4 + 77.3 * (state - 1)),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  252, 156, 159, 1),
                                              borderRadius:
                                                  BorderRadius.circular(90)),
                                          width: 13,
                                          height: 13),
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${name} 님은\n 현재 ${rank} 등급입니다.',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    detail = true;
                                  });
                                },
                                child: Text(
                                  '전체 등급별 혜택보기',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2),
                                ),
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            detail
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        SizedBox(height: 140),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 607,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '  등급별 혜택',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          detail = false;
                                        });
                                      },
                                      child: Text(
                                        'X',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '   PITCH란?\n   주행 후 자동으로 적립되며 다양한 혜택을 누릴 수 있어요\n   이동거리 300m이상, 이용시간 3분 이상 시 적용돼요',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    height: 1.4,
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/r1.png',
                                      width: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '새싹',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'PITCH 5점 이상',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFE2FF92),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            Text(
                                              '  씨앗 30개 제공',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                //
                                SizedBox(height: 25),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/r2.png',
                                      width: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '나뭇잎',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'PITCH 10점 이상',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFE2FF92),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            Text(
                                              '  씨앗 100개 제공',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 25),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/r3.png',
                                      width: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '나뭇가지',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'PITCH 50점 이상',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFE2FF92),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            Text(
                                              '  씨앗 1000개 제공',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 25),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/r4.png',
                                      width: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '꽃',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'PITCH 100점 이상',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFE2FF92),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            Text(
                                              '  씨앗 2000개, 잠금해제 mini 제공',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 25),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/r5.png',
                                      width: 60,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '복숭아',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'PITCH 300점 이상',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Container(
                                              width: 15,
                                              height: 15,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFE2FF92),
                                                shape: OvalBorder(),
                                              ),
                                            ),
                                            Text(
                                              '  씨앗 5000개, 잠금해제 MAX 제공',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  '*랭킹별 혜택 수령 이후 30일 동안은 중복 수혜 불가\n*90일 동안 서비스 미사용 시 점수 초기화',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ]),
    );
  }
}
