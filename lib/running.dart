import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safety/ai.dart';
import 'package:safety/tr.dart';
import 'package:shared_preferences/shared_preferences.dart';

late List<CameraDescription> cameras;

class running extends StatefulWidget {
  const running({super.key});

  @override
  State<running> createState() => _runningState();
}

class _runningState extends State<running> {
  dynamic check = '';

  void createDocument() async {
    CollectionReference historyCollection = FirebaseFirestore.instance
        .collection('vehicles')
        .doc('vehicle1')
        .collection('history');

    DocumentReference newDocumentRef = historyCollection.doc();

    // 문서에 저장할 데이터
    Map<String, dynamic> data = {
      'datetime': DateTime.now(),
      'illegal': false,
      'upright': true
    };

    await newDocumentRef.set(data); // 문서를 생성하고 데이터 저장

    String newDocumentId = newDocumentRef.id; // 생성된 문서의 ID 가져오기
    SharedPreferences Docu_ID = await SharedPreferences.getInstance();
    Docu_ID.setString('ID', newDocumentId);
    setState(() {
      check = newDocumentId;
    });
  }

  void get_camera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  @override
  void initState() {
    // createDocument();
    super.initState();
    get_camera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 70),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15)),
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  '현재 위치 :인천광역시 미추홀구 용현1. 4동',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(0, 0, 0, 0.8)),
                ),
              ),
              SizedBox(height: 60),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Expanded(
                  child: Image.asset(
                    width: 300,
                    height: 300,
                    'assets/image.PNG',
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.center,
                height: 60,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 156, 159, 0.4),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '반납 방식을 선택해주세요',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.9), fontSize: 20),
                ),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Container(
                      height: 50,
                      width: 150,
                      child: Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(242, 156, 159, 0.6))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/QR_end');
                            },
                            child: Text(
                              'QR 인식',
                            )),
                      )),
                  SizedBox(width: 40),
                  Container(
                      height: 50,
                      width: 150,
                      child: Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromRGBO(242, 156, 159, 0.6))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AIwidget(cameras: cameras)));
                            },
                            child: Text(
                              '카메라',
                            )),
                      ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
