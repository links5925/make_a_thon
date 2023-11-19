import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tflite_v2/tflite_v2.dart';

typedef void Callback(List<dynamic> list);

class AIwidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  AIwidget({required this.cameras});

  @override
  _AIwidgetState createState() => _AIwidgetState();
}

class _AIwidgetState extends State<AIwidget> {
  String predOne = '';
  double confidence = 0;
  double index = 0;
  bool isDetecting = false;
  dynamic test_data;
  bool check = false;

  @override
  void initState() {
    super.initState();
    loadTfliteModel();
  }

  loadTfliteModel() async {
    Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  setRecognitions(outputs) {
    if (outputs[0]['index'] == 1) {
      if (outputs[0]['confidence'] > 0.6) {
        setState(() {
          check = true;
        });
      } else {
        setState(() {
          check = false;
        });
      }
    } else {
      check = false;
    }

    confidence = outputs[0]['confidence'];

    setState(() {
      predOne = outputs[0]['label'];
    });
  }

  Future<void> upload_user_data() async {
    int point = 1;
    final data = FirebaseFirestore.instance
        .collection("vehicles")
        .doc("vehicle1")
        .collection("history")
        .doc("stable");

    DocumentSnapshot s = await data.get();
    if (s.exists) {
      test_data = s.data();
      if (test_data['safe']) {
        point += 1;
      }
    }

    final userLogReference =
        FirebaseFirestore.instance.collection("users").doc("user1");
    DocumentSnapshot snapshot = await userLogReference.get();
    if (snapshot.exists) {
      test_data = snapshot.data();
    }
    String day = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String hour = DateFormat("HH:mm").format(DateTime.now());
    userLogReference
        .collection('history')
        .doc()
        .set({"datalog": point, "day": day, "hour": hour, "cost": 1000});

    dynamic new_data = {
      "name": test_data["name"],
      "point": test_data["point"] + point
    };

    FirebaseFirestore.instance
        .collection("users")
        .doc("user1")
        .update(new_data);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white.withOpacity(0.95),
            centerTitle: true,
            title: Text(
              '바른 주차문화 만들기',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.9),
          body: Column(
            children: [
              Camera(widget.cameras, setRecognitions),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    SizedBox(height: 200),
                    Text(
                      '촬영버튼이 분홍색으로 변하면 눌러주세요!',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor:
                check ? Color.fromRGBO(252, 156, 159, 1) : Colors.blue,
            onPressed: () {
              if (check) {
                upload_user_data().then((value) {
                  Navigator.pushNamed(context, '/end');
                });
              }
            },
            child: Icon(Icons.camera_alt),
          )),
    );
  }
}

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  Camera(this.cameras, this.setRecognitions);
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController cameraController;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    cameraController =
        CameraController(widget.cameras.first, ResolutionPreset.high);
    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});

      cameraController.startImageStream((image) {
        if (!isDetecting) {
          isDetecting = true;
          Tflite.runModelOnFrame(
            bytesList: image.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: image.height,
            imageWidth: image.width,
            numResults: 1,
          ).then((value) {
            if (value!.isNotEmpty) {
              widget.setRecognitions(value);
              isDetecting = false;
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!cameraController.value.isInitialized) {
      return Container();
    }

    return Transform.scale(
      scale: 1.78,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: CameraPreview(cameraController),
        ),
      ),
    );
  }
}
