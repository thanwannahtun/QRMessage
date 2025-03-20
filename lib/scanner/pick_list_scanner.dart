import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrmessage/scanner/barcode_at_center.dart';
import 'package:qrmessage/scanner/scanner_error_widget.dart';

import 'cross_hair.dart';

// This sample implements picklist functionality.
// The scanning can temporarily be suspended by the user by touching the screen.
// When the scanning is active, the crosshair turns red.
// When the scanning is suspended, the crosshair turns green.
// A barcode has to touch the center of viewfinder to be scanned.
// Therefore the Crosshair widget needs to be placed at the center of the
// MobileScanner widget to visually line up.
class BarcodeScannerPicklist extends StatefulWidget {
  const BarcodeScannerPicklist({super.key});

  @override
  State<BarcodeScannerPicklist> createState() => _BarcodeScannerPicklistState();
}

class _BarcodeScannerPicklistState extends State<BarcodeScannerPicklist> {
  final _mobileScannerController = MobileScannerController(
    // The controller is started from the initState method.
    autoStart: false,
  );

  final orientation = DeviceOrientation.portraitUp;

  // On this subscription the barcodes are received.
  StreamSubscription<Object?>? _subscription;

  // This boolean indicates if the detection of barcodes is enabled or
  // temporarily suspended.
  final _scannerEnabled = ValueNotifier(true);

  // This boolean is used to prevent multiple pops.
  var _validBarcodeFound = false;

  @override
  void initState() {
    // Lock to portrait (may not work on iPad with multitasking).
    SystemChrome.setPreferredOrientations([orientation]);
    // Get a stream subscription and listen to received barcodes.
    _subscription = _mobileScannerController.barcodes.listen(_handleBarcodes);
    super.initState();
    // Start the controller to start scanning.
    unawaited(_mobileScannerController.start());
  }

  @override
  void dispose() {
    // Cancel the stream subscription.
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    // Dispose the controller.
    _mobileScannerController.dispose();
  }

  // Check the list of barcodes only if scannerEnables is true.
  // Only take the barcode that is at the center of the image.
  // Return the barcode found to the calling page with the help of the
  // navigator.
  void _handleBarcodes(BarcodeCapture barcodeCapture) {
    // Discard all events when the scanner is disabled or when already a valid
    // barcode is found.
    if (!_scannerEnabled.value || _validBarcodeFound) {
      return;
    }
    final barcode = findBarcodeAtCenter(barcodeCapture, orientation);
    if (barcode != null) {
      _validBarcodeFound = true;
      Navigator.of(context).pop(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // Reset the page orientation to the system default values, when this page is popped
        if (!didPop) {
          return;
        }
        SystemChrome.setPreferredOrientations(<DeviceOrientation>[]);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Scanning...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.black,
        body: Listener(
          // Detect if the user touches the screen and disable/enable the scanner accordingly
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) => _scannerEnabled.value = false,
          onPointerUp: (_) => _scannerEnabled.value = true,
          onPointerCancel: (_) => _scannerEnabled.value = true,
          // A stack containing the image feed and the crosshair
          // The location of the crosshair must be at the center of the MobileScanner, otherwise the detection area and the visual representation do not line up.
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 110,horizontal: 11),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                // color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MobileScanner(
                    controller: _mobileScannerController,
                    errorBuilder:
                        (context, error, child) =>
                            ScannerErrorWidget(error: error),
                    fit: BoxFit.contain,
                  ),
                  Crosshair(_scannerEnabled),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
