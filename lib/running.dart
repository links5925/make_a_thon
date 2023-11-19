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
  int page = 1;

  void createDocument() async {
    CollectionReference historyCollection = FirebaseFirestore.instance
        .collection('vehicles')
        .doc('vehicle1')
        .collection('history');

    DocumentReference newDocumentRef = historyCollection.doc();

    // 문서에 저장할 데이터
    Map<String, dynamic> data = {
      'datetime': DateTime.now(),
      'safe': true,
      'upright': true
    };

    FirebaseFirestore.instance
        .collection("vehicles")
        .doc("vehicle1")
        .collection('history')
        .doc('stable')
        .update(data);

    await newDocumentRef.set(data); // 문서를 생성하고 데이터 저장
  }

  void get_camera() async {
    cameras = await availableCameras();
    setState(() {});
  }

  @override
  void initState() {
    createDocument();
    super.initState();
    get_camera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 145),
                Image.asset('assets/image.PNG',
                    width: MediaQuery.of(context).size.width),
              ],
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.sizeOf(context).width,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.transparent),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  height: 50,
                  child: Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(Icons.location_on),
                      Text(
                        '  현재 위치 : 인천광역시 미추홀구 용현1.4동',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  '반납 방식을 선택해주세요',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 60,
                        width: 160,
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
                                      Color.fromRGBO(240, 174, 168, 1))),
                              onPressed: () {
                                Navigator.pushNamed(context, '/QR_end');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    ' QR 인식',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              )),
                        )),
                    SizedBox(width: 30),
                    Container(
                        height: 60,
                        width: 160,
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
                                      Color.fromRGBO(240, 174, 168, 1))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AIwidget(cameras: cameras)));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  Text(' 카메라', style: TextStyle(fontSize: 20)),
                                ],
                              )),
                        )),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.info_outline_rounded),
                    Text(' 반납방식이란?'),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  '주차구역에 있는 QR코드를 스캔하거나 \n카메라가 PEACH색 주차선을 인식할 경우 반납할 수 있어요!',
                ),
                SizedBox(height: 50)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
