import 'package:flutter/material.dart';

class userPage extends StatefulWidget {
  const userPage({super.key});

  @override
  State<userPage> createState() => _userPageState();
}

class _userPageState extends State<userPage> {
  double p = 0.9;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
      Text('  나의 라이딩 등급',
      style: TextStyle(fontSize: 25,color: Colors.black.withOpacity(0.8)),
      ),
      Container(padding: EdgeInsets.all(20),width: MediaQuery.of(context).size.width*0.9,height: 150,
      decoration: BoxDecoration(color: Color.fromRGBO(240, 174, 168, 1),borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person,size:35),
              Text('  랭크',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),) 
              ],),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 168, 160, 1)),
                child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7 * p,
                    height: 10,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(90)),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7 * p,
                    height: 10,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(252, 156, 159, 1).withOpacity(0.2),
                              Color.fromRGBO(252, 156, 159, 1).withOpacity(0.8)
                            ]),
                        borderRadius: BorderRadius.circular(90)),
                  )
                ],
              ),
                ),
                )],
                ),
          ),

      ]),
      
      );
  }
}