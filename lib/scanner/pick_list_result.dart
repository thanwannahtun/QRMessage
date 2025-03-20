import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrmessage/models/Message.dart';
import 'package:qrmessage/scanner/pick_list_scanner.dart';

// import '../screens/qr_scanner_screen.dart';
import '../utils/encryption_util.dart';

class PicklistResult extends StatefulWidget {
  const PicklistResult({super.key, this.directScan = false});

  final bool? directScan;

  @override
  State<PicklistResult> createState() => _PicklistResultState();
}

class _PicklistResultState extends State<PicklistResult> {
  final MobileScannerController _controller = MobileScannerController();

  MessageData? barcode;

  @override
  void initState() {
    if (widget.directScan ?? false) {
      Future.delayed(Duration(microseconds: 10)).then((_) {
        if (mounted) {
          scanQR(context);
        }
      });
    }
    super.initState();
  }

  Future<void> _analyzeImageFromFile() async {
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (!mounted) {
        return;
      }

      if (kDebugMode) {
        print("---> file :: $file <--- ");
      }
      if (file == null) {
        showSnackBar("No file selected!");
        return;
      }

      final BarcodeCapture? barcodeCapture = await _controller.analyzeImage(
        file.path,
      );

      if (barcodeCapture == null) {
        // textBarcode = 'Scan Something!';
        showSnackBar("Barcode is not found!");
        return;
      }
      if (barcodeCapture.barcodes.firstOrNull?.rawValue == null) {
        // textBarcode = '>>binary<<';
        showSnackBar("Something went wrong!!");
        return;
      }

      setState(() {
        try {
          String decryptedJson = EncryptionUtil.decryptData(
            barcodeCapture.barcodes.firstOrNull?.rawValue ?? '',
          );
          if (kDebugMode) {
            print("---> decryptedJson :: $decryptedJson <--- ");
          }
          barcode = MessageData.fromJson(
            jsonDecode(decryptedJson) as Map<String, dynamic>,
          );
          if (kDebugMode) {
            print("---> barcode :: ${barcode.toString()} <--- ");
          }
        } catch (e, stackTrace) {
          if (kDebugMode) {
            print("---> error :: ${e.toString()} <---");
            print("---> stackTrace :: $stackTrace <---");
          }
          showSnackBar("Invalid QR Code!");
        }
      });
    } catch (_) {
      showSnackBar("Something went wrong!!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan Message",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: _actions(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card.filled(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
                    color: colorScheme.onInverseSurface,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 25,
                      ),
                      child: Center(
                        child:
                            barcode == null
                                ? Text(
                                  "Scan Others' Message!",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Verdana",
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer,
                                  ),
                                )
                                : Column(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: SingleChildScrollView(
                                          child: Center(
                                            child: Text(
                                              barcode?.data ?? "-",
                                              style: barcode!
                                                  .messageType
                                                  .fontStyle
                                                  .copyWith(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    /// feeling
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            barcode!.messageType.emojis
                                                .map(
                                                  (emoji) => Expanded(
                                                    child: Text(emoji),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.inverseSurface,
                        foregroundColor: colorScheme.inversePrimary,
                      ),
                      onPressed: () async {
                        await scanQR(context);
                      },
                      child: Row(
                        spacing: 20,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Scan'),
                          Icon(
                            Icons.qr_code_scanner_rounded,
                            color: colorScheme.inversePrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scanQR(BuildContext context) async {
    final scannedBarcode = await Navigator.of(context).push<Barcode>(
      MaterialPageRoute(builder: (context) => const BarcodeScannerPicklist()),
    );
    try {
      setState(() {
        if (scannedBarcode == null) {
          showSnackBar("Barcode is not found!");
          return;
        }
        if (scannedBarcode.displayValue == null) {
          showSnackBar("Something went wrong!!");
          return;
        }
        if (kDebugMode) {
          print(
            "---> scannedBarcode :: ${scannedBarcode.displayValue ?? ''} <---",
          );
        }

        String decryptedJson = EncryptionUtil.decryptData(
          scannedBarcode.displayValue!,
        );
        if (kDebugMode) {
          print("---> decryptedJson :: $decryptedJson <---");
        }
        barcode = MessageData.fromJson(
          jsonDecode(decryptedJson) as Map<String, dynamic>,
        );
        if (kDebugMode) {
          print("---> barcode :: ${barcode.toString()} <--- ");
        }
      });

      ///
    } catch (e) {
      setState(() {
        showSnackBar("Invalid QR Code!");
      });
    }
  }

  List<Widget> _actions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          showMenu(
            context: context,
            items: [
              PopupMenuItem(
                onTap: kIsWeb ? null : _analyzeImageFromFile,
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.file_present_rounded),
                    Text("Scan From File"),

                    // Icon(Icons.file_present_rounded),
                    // Text("Pick From File"),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {},
                child: Row(
                  spacing: 10,
                  children: [Icon(Icons.share_rounded), Text("Share Message")],
                ),
              ),
              PopupMenuItem(
                onTap: () {},
                child: Row(
                  spacing: 10,
                  children: [Icon(Icons.save_rounded), Text("Save to Gallery")],
                ),
              ),
            ],
            position: RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width - 100,
              0,
              0,
              0,
            ),
          );
        },
        icon: Icon(Icons.more_vert_rounded),
      ),
    ];
  }

  showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Helvetica",
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
