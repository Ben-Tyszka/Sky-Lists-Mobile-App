import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:soundpool/soundpool.dart';

import 'package:sky_lists/utils/decode_qr.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page.dart';
import 'package:sky_lists/presentational_widgets/pages/sky_list_page_arguments.dart';
import 'package:sky_lists/database_service.dart';

class QRScannerPage extends StatefulWidget {
  static final String routeName = '/qr_scanner_page';

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  QRReaderController controller;
  bool authorized = false;

  final _db = DatabaseService();

  @override
  void initState() {
    super.initState();
    work();
  }

  work() async {
    final flag = await perm.PermissionHandler()
        .checkPermissionStatus(perm.PermissionGroup.camera);

    if (flag != perm.PermissionStatus.granted) {
      final status = await perm.PermissionHandler()
          .requestPermissions([perm.PermissionGroup.camera]);
      if (status[0] == perm.PermissionStatus.granted) {
        setState(() {
          authorized = true;
        });
      } else {
        setState(() {
          authorized = false;
        });
      }
    } else {
      setState(() {
        authorized = true;
      });
    }

    if (authorized) {
      List<CameraDescription> cameras;
      cameras = await availableCameras();
      controller = QRReaderController(
        cameras[0],
        ResolutionPreset.medium,
        [CodeFormat.qr],
        shareList,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
        controller.startScanning();
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  shareList(String value) async {
    controller.stopScanning();

    try {
      final data = decodeQR(value);

      Soundpool pool = Soundpool(streamType: StreamType.notification);

      int soundId = await rootBundle
          .load("assets/correct.wav")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });

      pool.play(soundId);
      Vibration.vibrate();

      _db
          .getListMetaFromIds(listId: data.listId, ownerId: data.ownerId)
          .then((list) {
        _db
            .shareList(
          list: list,
          ownerId: data.ownerId,
          sharedWithId: Provider.of<FirebaseUser>(context),
        )
            .then((val) {
          Navigator.popAndPushNamed(
            context,
            SkyListPage.routeName,
            arguments: SkyListPageArguments(list),
          );
        });
      });
    } catch (e) {
      controller.startScanning();
      print('invalid code');
    }
  }

  Widget renderCamera() {
    if (controller == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return !controller.value.isInitialized
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: QRReaderPreview(controller),
          );
  }

  Widget cameraView() {
    return Stack(
      children: <Widget>[
        Container(
          child: SizedBox.expand(
            child: renderCamera(),
          ),
        ),
        Center(
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 300.0,
                width: 300.0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0,
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget notAuthorized() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'In order to use the QR scanner we must have access to your camera.',
          ),
          RaisedButton.icon(
            icon: Icon(
              Icons.camera,
            ),
            label: Text(
              'Grant Access to Camera',
            ),
            onPressed: () async {
              final status = await perm.PermissionHandler()
                  .requestPermissions([perm.PermissionGroup.camera]);
              if (status[0] == perm.PermissionStatus.granted) {
                setState(() {
                  authorized = true;
                });
              } else {
                setState(() {
                  authorized = false;
                });
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan List QR Code'),
      ),
      body: cameraView(),
    );
  }
}
