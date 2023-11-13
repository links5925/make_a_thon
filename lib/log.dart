import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class log extends StatefulWidget {
  const log({super.key});

  @override
  State<log> createState() => _logState();
}

class _logState extends State<log> {
  dynamic user_point_data;
  List<dynamic> user_log_data = [];
  bool data_reading = false;

  Future<void> readData() async {
    dynamic userPointReference =
        FirebaseFirestore.instance.collection("users").doc("user1");
    userPointReference.get().then((value) => {
          setState(() {
            user_point_data = value.data();
            data_reading = true;
          }),
        });
    dynamic userLogReference = FirebaseFirestore.instance
        .collection("users")
        .doc("user1")
        .collection("history");
    userLogReference.get().then((QuerySnapshot querySnapshot) => {
          setState(() {
            user_log_data =
                querySnapshot.docs.map((doc) => doc.data()).toList();
          })
        });
  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: 50),
        Text(
          '이용내역',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 30),
        Container(
          alignment: Alignment.topCenter,
          child: data_reading
              ? Text(
                  '${user_point_data['point']}point',
                  style: TextStyle(
                      fontSize: 20, color: Color.fromRGBO(252, 156, 159, 1)),
                )
              : Container(),
        ),
        // Text('${user_log_data}'),
        SizedBox(height: 20),
        Column(
          children: [
            SizedBox(height: 20),
            Container(
              height: 500,
              child: ListView.builder(
                  itemCount: user_log_data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return makesomething(context, user_log_data[i]['datetime'],
                        user_log_data[i]['datalog']);
                  }),
            ),
          ],
        )
      ]),
    );
  }

  Widget makesomething(BuildContext context, String time, int datalog) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(right: 20, left: 15),
          height: 60,
          child: Row(
            children: [
              Text(
                time,
                style: TextStyle(color: Colors.black),
              ),
              Spacer(),
              Text(
                '$datalog',
                style: TextStyle(
                    color: Color.fromRGBO(252, 156, 159, 1), fontSize: 20),
              )
            ],
          ),
        ),
        SizedBox(height: 5)
      ],
    );
  }
}
