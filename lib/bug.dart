import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class bug extends StatefulWidget {
  const bug({super.key});

  @override
  State<bug> createState() => _bugState();
}

class _bugState extends State<bug> {
  void right() {
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
  }

  void wrong() {
    Map<String, dynamic> data = {
      'datetime': DateTime.now(),
      'safe': false,
      'upright': true
    };

    FirebaseFirestore.instance
        .collection("vehicles")
        .doc("vehicle1")
        .collection('history')
        .doc('stable')
        .update(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: right, child: Text('흔들림')),
            SizedBox(
              width: 30,
            ),
            ElevatedButton(onPressed: wrong, child: Text('안정됨'))
          ],
        ),
      ),
    );
  }
}
