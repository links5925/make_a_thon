import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Map<String, dynamic> data = {'datetime': DateTime.now(), 'illegal': false, 'upright':true};

    await newDocumentRef.set(data); // 문서를 생성하고 데이터 저장

    String newDocumentId = newDocumentRef.id; // 생성된 문서의 ID 가져오기
    SharedPreferences Docu_ID = await SharedPreferences.getInstance();
    Docu_ID.setString('ID', newDocumentId);
    setState(() {
      check = newDocumentId;
    });
  }

  @override
  void initState() {
    createDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('측정중', style: TextStyle(fontSize: 50)),
              Text(check),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/QR_end');
                  },
                  child: Text(
                    'QR 인식',
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/real_camera');
                  },
                  child: Text(
                    '카메라',
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
