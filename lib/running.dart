import 'package:flutter/material.dart';

class running extends StatefulWidget {
  const running({super.key});

  @override
  State<running> createState() => _runningState();
}

class _runningState extends State<running> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('운행중', style: TextStyle(fontSize: 50)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('홈',style: TextStyle(),))
            ],
          ),
        ],
      ),
    );
  }
}
