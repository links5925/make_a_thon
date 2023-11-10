import 'dart:math';

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
        Container(
          alignment: Alignment.topCenter,
          child: data_reading
              ? Text(
                  '${user_point_data['point']}point',
                  style: TextStyle(
                      fontSize: 60, color: Color.fromRGBO(252, 156, 159, 1)),
                )
              : Container(),
        ),
        Text('{user_log_data}'),
        Container(
          color: Colors.blue,
          height: 400,
          child: ListView.builder(
              itemCount: user_log_data.length,
              itemBuilder: (BuildContext context, int i) {
                makesomething(context, user_log_data[i]['datetime'],
                    user_log_data[i]['datalog']);
              }),
        )
      ]),
    );
  }

  Widget makesomething(BuildContext context, String time, String datalog) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.only(right: 20, left: 15),
      height: 60,
      width: 200,
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.black),
          ),
          Spacer(),
          Text(
            '$datalog',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
