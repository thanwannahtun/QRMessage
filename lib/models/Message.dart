import 'dart:convert';

import 'message_type.dart';

class MessageData {
  final String data;
  final MessageFeelingType messageType;

  const MessageData({required this.data, required this.messageType});

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
    data: json['d'] as String,
    messageType: MessageFeelingType.fromQRJson(json['mt']),
  );

  Map<String, dynamic> toJson() => {'d': data, 'mt': messageType.value};

  MessageData copyWith({String? data, MessageFeelingType? messageType}) {
    return MessageData(
      data: data ?? this.data,
      messageType: messageType ?? this.messageType,
    );
  }

  /// encode the MessageData instance
  String encodedData() => jsonEncode(toJson());

  // int byteSize = utf8.encode(jsonString).length;

  @override
  String toString() => "(data:$data , type:$messageType )";
}
