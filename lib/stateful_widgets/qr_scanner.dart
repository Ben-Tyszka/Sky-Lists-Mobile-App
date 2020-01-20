import 'dart:developer';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:sky_lists/utils/decode_qr.dart';

class QRScanner extends StatefulWidget {
  static final String routeName = '/qr_scanner_page';

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool _scanned = false;

  void _onResult(List<Barcode> barcodes) {
    if (!mounted || _scanned) {
      return;
    }
    setState(() {
      _scanned = true;
    });
    final rawValue = barcodes.first.rawValue;
    log(rawValue);
    final data = decodeQR(rawValue);
    log('ListId: ${data.listId} | Owner by: ${data.ownerId}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CameraMlVision<List<Barcode>>(
          detector: FirebaseVision.instance
              .barcodeDetector(
                BarcodeDetectorOptions(
                  barcodeFormats: BarcodeFormat.qrCode,
                ),
              )
              .detectInImage,
          onResult: _onResult,
        ),
      ),
    );
  }
}
