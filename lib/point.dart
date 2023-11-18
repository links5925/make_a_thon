import 'package:flutter/material.dart';

class pointwidget extends StatefulWidget {
  const pointwidget({super.key});

  @override
  State<pointwidget> createState() => _pointwidgetState();
}

class _pointwidgetState extends State<pointwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('상점'),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
          )
        ],
      ),
    );
  }
}
