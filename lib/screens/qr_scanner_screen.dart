import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  QRScannerScreen({super.key, this.onScanCompleted});

  ValueGetter<String>? onScanCompleted;

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String scannedText = "Scan a QR Code";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;

                if (barcodes.isEmpty || barcodes.first.rawValue == null) {
                  setState(() {
                    scannedText = "Invalid QR Code";
                  });
                } else {
                  String rawText = barcodes.first.rawValue!;
                  debugPrint("-------------------------- rawText ");
                  debugPrint("rawText :: $rawText");
                  try {
                    // Proper UTF-8 decoding
                    List<int> bytes = rawText.codeUnits; // Get byte list

                    // // Properly decode UTF-8 Burmese characters
                    // String decodedText = utf8.decode(
                    //   bytes,
                    //   allowMalformed: true,
                    // );
                    // setState(() {
                    //   scannedText = decodedText;
                    // });
                    debugPrint("-------------------------- bytes ");
                    debugPrint("bytes :: $bytes");
                    // String decodedText = utf8.decode(
                    //   bytes,
                    // );
                    /// Decode bytes to UTF-8 string
                    String decodedText = rawText;
                    debugPrint("-------------------------- decodedText ");
                    debugPrint("decodedText :: $decodedText");
                    setState(() {
                      scannedText = decodedText;
                      debugPrint("-------------------------- scannedText ");
                      debugPrint("scannedText :: $scannedText");
                    });
                  } catch (e) {
                    setState(() {
                      scannedText = "Error decoding QR: $e";
                      debugPrint("scannedText :: $scannedText");
                    });
                  }
                }
              },
            ),
          ),
          Container(
            color: Colors.amber,
            padding: EdgeInsets.all(16),
            child: Text(
              scannedText,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Noto Sans Myanmar',
              ), // Use Myanmar-supported font
            ),
          ),
        ],
      ),
    );
  }
}
