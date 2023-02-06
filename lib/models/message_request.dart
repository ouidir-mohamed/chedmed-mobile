import 'dart:convert';

import 'package:dio/dio.dart';

import 'message_type.dart';

class MessageRequest {
  int recipientId;
  String privateMessage;
  List<String> mediaPaths;
  int? voiceDuration;

  MessageType type;

  MessageRequest({
    required this.recipientId,
    required this.privateMessage,
    required this.mediaPaths,
    required this.type,
    this.voiceDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
      'privateMessage': privateMessage,
      'voiceDuration': voiceDuration,
      'type': type.toJson()
    };
  }

  Future<FormData> toFormData() async {
    var formData = FormData.fromMap(toJson());
    for (var file in mediaPaths) {
      formData.files.addAll([
        MapEntry("medias", await MultipartFile.fromFile(file)),
      ]);
    }
    print(formData.fields);
    return formData;
  }

  @override
  String toString() =>
      'MessageRequest(recipientId: $recipientId, privateMessage: $privateMessage)';

  @override
  int get hashCode => recipientId.hashCode ^ privateMessage.hashCode;
}
