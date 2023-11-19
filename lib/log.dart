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
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '   이용내역',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            alignment: Alignment.topCenter,
            child: data_reading
                ? Column(
                    children: [
                      Divider(thickness: 2),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '     PITCH: ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(252, 156, 159, 1)),
                          ),
                          Text(
                            '${user_point_data['point']}P',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(252, 156, 159, 1)),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(),
          ),
        ),
        SizedBox(height: 3),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '       최근 3개월 이내의 데이를 조회한 결과입니다',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Column(
          children: [
            Container(
              height: 500,
              child: ListView.builder(
                  itemCount: user_log_data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return makesomething(
                        context,
                        user_log_data[i]['day'],
                        user_log_data[i]['hour'],
                        user_log_data[i]['datalog'],
                        user_log_data[i]['cost']);
                  }),
            ),
          ],
        )
      ]),
    );
  }

  Widget makesomething(
      BuildContext context, String day, String time, int datalog, int cost) {
    return Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(color: Colors.grey.withOpacity(0.6))),
          padding: EdgeInsets.only(right: 20, left: 5),
          height: 80,
          child: Row(
            children: [
              SizedBox(width: 5),
              Image.asset(
                'assets/ve.png',
                width: 30,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${cost}₩'),
                  SizedBox(height: 7),
                  Text(
                    'PITCH : +${datalog}P',
                    style: TextStyle(
                        color: Color.fromRGBO(252, 156, 159, 1), fontSize: 14),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(height: 15)
      ],
    );
  }
}
