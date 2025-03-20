import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:qrmessage/models/Message.dart';
import 'package:qrmessage/scanner/pick_list_result.dart';
import 'package:qrmessage/utils/encryption_util.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'models/message_type.dart';

import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class QRMessageApp extends StatelessWidget {
  const QRMessageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QRMessageHomePage(),
      title: 'QR Message',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
      ),
    );
  }
}

class QRMessageHomePage extends StatefulWidget {
  const QRMessageHomePage({super.key});

  @override
  State<QRMessageHomePage> createState() => _QRMessageHomePageState();
}

class _QRMessageHomePageState extends State<QRMessageHomePage> {
  MessageFeelingType _selectedFeeling = MessageFeelingType.happy;
  final TextEditingController _messageController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScreenshotController _screenshotController = ScreenshotController();

  final _messageFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  _unFocus() {
    _messageFocusNode.unfocus();
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _audioPlayer.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Message',style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PicklistResult(directScan: true,)),
              );
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool widerScreen = constraints.maxWidth > constraints.maxHeight;
          bool largerScreen = constraints.maxWidth > 860;

          double hor =
              largerScreen
                  ? 50
                  : widerScreen
                  ? 30
                  : 15;
          double ver =
              largerScreen
                  ? 20
                  : widerScreen
                  ? 15
                  : 10;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: hor, vertical: ver),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          Card.filled(
                            // pad,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              child: TextFormField(
                                focusNode: _messageFocusNode,
                                controller: _messageController,
                                minLines: 2,
                                maxLines: 15,
                                maxLength: 300,
                                onTapUpOutside: (event) => _unFocus(),
                                onTapOutside: (event) => _unFocus(),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "Enter your message..",
                                  labelStyle: TextStyle(
                                    fontFamily: "ComicSans",
                                  ),
                                ),
                                validator: (value) {
                                  if (value?.isEmpty ?? false) {
                                    _messageFocusNode.requestFocus();
                                    return "Enter your message!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "What's for?",
                                  style: TextStyle(
                                    color: colorScheme.inverseSurface,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                    // color: colorScheme.inversePrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Card.filled(
                            child: DropdownButton<MessageFeelingType>(
                              borderRadius: BorderRadius.circular(20),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              dropdownColor: colorScheme.onInverseSurface,
                              isDense: true,
                              underline: Container(),
                              isExpanded: true,
                              style: TextStyle(
                                color: colorScheme.inverseSurface,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Courier New",
                              ),
                              menuMaxHeight:
                                  MediaQuery.sizeOf(context).height * 0.7,
                              value: _selectedFeeling,
                              onChanged: (MessageFeelingType? newValue) {
                                setState(() {
                                  _selectedFeeling = newValue!;
                                });
                              },
                              items:
                                  MessageFeelingType.values.map((
                                    MessageFeelingType feeling,
                                  ) {
                                    return DropdownMenuItem<MessageFeelingType>(
                                      value: feeling,
                                      child: Text(feeling.value),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _qrcodeButton(colorScheme, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Container _qrcodeButton(ColorScheme colorScheme, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.inverseSurface,
            foregroundColor: colorScheme.inversePrimary,
          ),
          onPressed: () {
            _generateQRCode(context);
          },
          child: Text(
            'Get QR Code',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "Helvetica",
            ),
          ),
        ),
      ),
    );
  }

  void _generateQRCode(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final String message = _messageController.text;

      /// Convert to UTF-8 hex
      String utf8EncodedText =
          utf8.encode(message).map((e) => e.toRadixString(16)).join();

      final MessageFeelingType feeling = _selectedFeeling;
      await _audioPlayer.play(AssetSource(feeling.soundEffect));
      // await _audioPlayer.play(AssetSource("sounds/vinyl-stop-sound-effect.mp3"));
      debugPrint("playing a ${feeling.soundEffect} sound effect..!");
      // _audioPlayer.play(feeling.soundEffect as Source, isLocal: true);

      final qrData =
          MessageData(
            // data: utf8EncodedText,
            data: _messageController.text,
            messageType: feeling,
          ).encodedData();

      final encryptedData = EncryptionUtil.encryptData(qrData);

      if (kDebugMode) {
        print("encryptedData :: $encryptedData");
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Tooltip(message: "Close", child: Icon(Icons.close)),
                    ),
                  ),
                ),

                Center(
                  child: AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    content: Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
                          maxWidth:
                              MediaQuery.sizeOf(context).width >
                                      MediaQuery.sizeOf(context).height
                                  ? MediaQuery.sizeOf(context).width * 0.5
                                  : MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        child: Card.filled(
                          // margin: EdgeInsets.zero,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 23.0,
                            ),
                            child: Column(
                              spacing: 15,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                QrImageView(
                                  data: encryptedData,
                                  // data:
                                  //     '$utf8EncodedText\nFeeling: ${feeling.value}',
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  dataModuleStyle: QrDataModuleStyle(
                                    // color: feeling.backgroundColor,
                                    color: getRandomPaleBackground(),
                                    dataModuleShape: QrDataModuleShape.circle,
                                  ),
                                  eyeStyle: QrEyeStyle(
                                    eyeShape:
                                        Random().nextBool()
                                            ? QrEyeShape.square
                                            : QrEyeShape.circle,
                                    color: feeling.backgroundColor,
                                  ),
                                  // embeddedImageStyle: QrEmbeddedImageStyle(color: Colors.red,size: Size(100, 100)),
                                ),
                                // Text(
                                //   message,
                                //   style: feeling.fontStyle,
                                //   maxLines: 12,
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                                // Text(
                                //   'Feeling: ${feeling.valueText}',
                                //   style: feeling.fontStyle,
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      feeling.emojis
                                          .map(
                                            (emoji) =>
                                                Expanded(child: Text(emoji)),
                                          )
                                          .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 10,
                  right: 10,
                  child: ListTile(
                    title: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.inverseSurface,
                        foregroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () => _takeScreenshotAndShare(),
                      tooltip: "Share",
                      icon: Row(
                        spacing: 15,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Share",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontFamily: "Helvetica",
                            ),
                          ),
                          Icon(Icons.send),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _takeScreenshotAndShare() async {
    await _screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((image) async {
          if (image != null) {
            // final directory = await getApplicationDocumentsDirectory();
            final directory = await getTemporaryDirectory();
            String fileName =
                '${directory.path}/${DateTime.now().microsecondsSinceEpoch}-hello.png';

            final file = File(fileName);

            await file.create(recursive: true);
            await file.writeAsBytes(image);

            if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
              // Open the file instead of sharing
              await UrlLauncherPlatform.instance.launchUrl(
                file.path,
                LaunchOptions(),
              );
            } else {
              // Share Plugin
              await Share.shareXFiles([XFile(file.path)]);
            }
          }
        });
  }
}

MessageFeelingType getRandomFeeling() {
  final values = MessageFeelingType.values;
  return values[Random().nextInt(values.length)];
}

Color lightenColor(Color color, [double amount = 0.3]) {
  final hsl = HSLColor.fromColor(color);
  final lighterHSL = hsl.withLightness(
    (hsl.lightness + amount).clamp(0.0, 1.0),
  );
  return lighterHSL.toColor();
}

Color getRandomPaleBackground() {
  MessageFeelingType randomFeeling = getRandomFeeling();
  return lightenColor(
    randomFeeling.backgroundColor,
    // 0.3,
    0.1,
  ); // Adjust amount as needed
}

void main() {
  runApp(QRMessageApp());
}

/*
import 'dart:convert';

void main() {
  Map<String, dynamic> jsonData = {
    "case_id": "123456",
    "created_by": "data_entry_user1",
    "created_at": "2025-03-17T10:00:00Z",
    "status": "Pending"
  };

  String jsonString = jsonEncode(jsonData);
  int byteSize = utf8.encode(jsonString).length;

  print("JSON Size: $byteSize bytes");
}

/// 2





*/
