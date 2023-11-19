import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QR_start extends StatefulWidget {
  const QR_start({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QR_startState();
}

class _QR_startState extends State<QR_start> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String myVariable = '';
  StreamSubscription<QuerySnapshot>? _subscription;
  dynamic check = '';

  @override
  void initState() {
    super.initState();
  }

  void get_realtime_data_id() {
    FirebaseFirestore.instance
        .collection('vehicles')
        .doc('vehicle1')
        .collection('history')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) {
        if (change.type == DocumentChangeType.added) {
          String documentId = change.doc.id;
          setState(() {
            check = documentId;
          });
        }
      });
    });
  }

  void realtime_data() {
    FirebaseFirestore.instance
        .collection('vehicles')
        .doc('vehicle1')
        .collection('history')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      snapshot.docChanges.forEach((DocumentChange change) {
        if (change.type == DocumentChangeType.added) {
          setState(() {
            check = change.doc.data();
          });
        }
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'QR 코드 스캔',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Color.fromRGBO(242, 156, 159, 1),
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'QR코드 위치를 확인하여\n 스캔합니다',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 250),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 50,
                          )),
                      SizedBox(height: 10),
                      Text(
                        '     Flash',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result?.code == 'Safety-first-test') {
        await controller.pauseCamera().then((value) {
          Navigator.pushNamed(context, '/running');
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    _subscription?.cancel();
  }
}

class QR_end extends StatefulWidget {
  const QR_end({super.key});

  @override
  State<QR_end> createState() => _QR_endState();
}

class _QR_endState extends State<QR_end> {
  Barcode? result;
  QRViewController? controller;
  dynamic test_data;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool check_bool = false;

  Future<void> get_bool_data() async {
    final DocumentReference documentRef = FirebaseFirestore.instance
        .collection("vehicles")
        .doc("vehicle1")
        .collection("history")
        .doc("stable");
    DocumentSnapshot snapshot = await documentRef.get();
    if (snapshot.exists) {
      dynamic data = snapshot.data();
      setState(() {
        check_bool = data["safe"];
      });
    }
  }

  Future<void> upload_user_data() async {
    int point = 1;
    if (check_bool) {
      point += 1;
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
  void initState() {
    super.initState();
    get_bool_data();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Color.fromRGBO(242, 156, 159, 1),
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'QR코드 위치를 확인하여\n 스캔합니다',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 250),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 50,
                          )),
                      SizedBox(height: 10),
                      Text(
                        '     Flash',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result?.code == 'Safety-first-end') {
        await controller.pauseCamera().then((value) {
          upload_user_data();
          Navigator.pushNamed(context, '/end');
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
