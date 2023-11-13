import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_v2/tflite_v2.dart';

class real_camera extends StatefulWidget {
  const real_camera({
    Key? key,
  }) : super(key: key);

  @override
  _real_cameraState createState() => _real_cameraState();
}

class _real_cameraState extends State<real_camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Timer? _timer;
  dynamic _recognitions;
  bool check = false;
  String? Document_id;
  bool check_bool = false;
  dynamic test_data;
  Future<void> get_bool_data() async {
    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection("vehicles")
        .doc("vehicle1")
        .collection("history")
        .doc(Document_id);
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();
      setState(() {
        check_bool = data['illegal'];
      });
    }
  }

  Future<void> get_docu_id() async {
    SharedPreferences Docu_ID = await SharedPreferences.getInstance();
    setState(() {
      Document_id = Docu_ID.getString('ID');
    });
  }

  Future<void> upload_user_data() async {
    int point = 1;
    if (check_bool) {
      point -= 1;
    }

    final userLogReference =
        FirebaseFirestore.instance.collection("users").doc("user1");
    DocumentSnapshot snapshot = await userLogReference.get();
    if (snapshot.exists) {
      test_data = snapshot.data();
    }
    String time = DateFormat("yyyy-MM-dd").format(DateTime.now());
    userLogReference.collection('history').doc().set({
      "datalog": point,
      "datetime": time,
    });

    dynamic new_data = {
      "name": test_data["name"],
      "point": test_data["point"] + point
    };

    FirebaseFirestore.instance
        .collection("users")
        .doc("user1")
        .update(new_data);
  }

  Future<void> _captureAndApplyModel() async {
    if (_controller.value.isInitialized) {
      try {
        XFile file = await _controller.takePicture();
        setState(() {});
        File image = File(file.path);
        detectimage(image);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future detectimage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    for (int i = 0; i < recognitions!.length; i++) {
      if (recognitions[i]['index'] == 1) {
        if (recognitions[i]['confidence'] > 0.6) {
          setState(() {
            check = true;
          });
        } else {
          setState(() {
            check = false;
          });
        }
      }
    }
    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  void initState() {
    super.initState();
    get_docu_id().then(
      (value) {
        get_bool_data();
      },
    );
    loadmodel();
    initCamera();
    _initializeControllerFuture = Future.value();
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _captureAndApplyModel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50),
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Text('$_recognitions')
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: check ? Color.fromRGBO(252, 156, 159, 1) : Colors.blue,
        onPressed: () {
          if (check) { 
            upload_user_data().then((value) {
              Navigator.pushNamed(context, '/');
            });
          }
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(imagePath)),
    );
  }
}
