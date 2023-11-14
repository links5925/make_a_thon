  import 'package:camera/camera.dart';
  import 'package:flutter/material.dart';
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
    late CameraController cameraController;
    bool isDetecting = false;
    @override
    void initState() {
      cameraController =
          CameraController(widget.cameras.first, ResolutionPreset.high);
      cameraController.initialize().then((value) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
      super.initState();
      loadTfliteModel();
    }

    loadTfliteModel() async {
      Tflite.loadModel(
          model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
    }

    setRecognitions(outputs) {
      print(outputs);

      if (outputs[0]['index'] == 0) {
        index = 0;
      } else {
        index = 1;
      }

      confidence = outputs[0]['confidence'];

      setState(() {
        predOne = outputs[0]['label'];
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "TensorFlow Lite App",
          ),
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: [
            Camera(widget.cameras, setRecognitions),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Apple',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: SizedBox(
                                      height: 32.0,
                                      child: Stack(
                                        children: [
                                          LinearProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.redAccent),
                                            value: index == 0 ? confidence : 0.0,
                                            backgroundColor:
                                                Colors.redAccent.withOpacity(0.2),
                                            minHeight: 50.0,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${index == 0 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Orange',
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: SizedBox(
                                      height: 32.0,
                                      child: Stack(
                                        children: [
                                          LinearProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.orangeAccent),
                                            value: index == 1 ? confidence : 0.0,
                                            backgroundColor: Colors.orangeAccent
                                                .withOpacity(0.2),
                                            minHeight: 50.0,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${index == 1 ? (confidence * 100).toStringAsFixed(0) : 0} %',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
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
        scale: 1 / cameraController.value.aspectRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: cameraController.value.aspectRatio,
            child: CameraPreview(cameraController),
          ),
        ),
      );
    }
  }
