import 'package:flutter/material.dart';

class pitch_detail extends StatefulWidget {
  const pitch_detail({super.key});

  @override
  State<pitch_detail> createState() => _pitch_detailState();
}

class _pitch_detailState extends State<pitch_detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Text('PITCH 이용가이드',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 70),
              Column(
                children: [
                  Container(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30),
                          Image.asset(
                            'assets/r5b.png',
                            width: 70,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'PITCH',
                                style: TextStyle(
                                    color: Color.fromRGBO(252, 156, 159, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '란 무엇인가요?',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            child: Column(
                              children: [
                                Text(
                                  'PITCH팀의 마일리지 개념으로,\n주행 후 자동 적립되며 다양한 혜택을 누릴 수 있어요!',
                                  style: TextStyle(
                                    height: 1.5,
                                    letterSpacing: 1,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '이동거리 300m이상,\n  3분 이상 이용시 적용돼요',
                                  style: TextStyle(
                                    height: 1.5,
                                    letterSpacing: 1,
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      )),
                  SizedBox(height: 60),
                  Text(
                    'PITCH를 통해\n 이런 혜택을 받을 수 있어요',
                    style: TextStyle(
                        fontSize: 25, height: 1.4, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        Icon(
                          Icons.currency_exchange,
                          size: 75,
                          color: Color.fromRGBO(252, 156, 159, 1),
                        ),
                        SizedBox(height: 25),
                        Text(
                          '상품으로 교환가능한 씨앗 수령',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          child: Column(
                            children: [
                              Text(
                                'PITCH를 통해 얻은 씨앗을 식권 및 지역화폐로 교환가능해요!',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 60),
                        Icon(
                          Icons.lock_open_outlined,
                          size: 75,
                          color: Color.fromRGBO(252, 156, 159, 1),
                        ),
                        SizedBox(height: 30),
                        Text(
                          '잠금해제 비용 무료',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: MediaQuery.sizeOf(context).width * 0.7,
                          child: Column(
                            children: [
                              Text(
                                '월 구독 mini로 이용 가능한 잠금해제 무료를 PITCH를 통해 즐겨보세요! 승급을 기점으로 5일간 잠금해제 비용이 사라집니다',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                  SizedBox(height: 20),
                  Text(
                    'PITCH와 함께 안전운전 하세요!',
                    style: TextStyle(
                        fontSize: 25, height: 1.4, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
