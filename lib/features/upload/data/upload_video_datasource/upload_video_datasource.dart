import 'dart:convert';

import 'package:api_video/commons/api.dart';
import 'package:api_video/features/home_page/data/video_model.dart';
import 'package:api_video/features/upload/blocs/upload_video_bloc/upload_video_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:video_uploader/video_uploader.dart';
import 'package:http/http.dart' as http;

class UploadVideoDataSource {
  final ApiVideoMobileUploaderPlugin uploaderPlugin =
      ApiVideoMobileUploaderPlugin();
  String basicAuth =
      'Basic ${base64.encode(utf8.encode('ldu4FXvopcyxcNJa17Ziey0vMAn1vkJ52XgXUE7Ru1R:'))}';
  Future<Video?> uploadVideo(UploadLocalVideoParams params) async {
    try {
      PercentageCalc.instance.reset();
      uploaderPlugin.setApiKey('ldu4FXvopcyxcNJa17Ziey0vMAn1vkJ52XgXUE7Ru1R');
      uploaderPlugin.setChunkSize(10042880);
      uploaderPlugin.setTimeout(10000);
      final videoObject = await createVideoObject(params);
      uploaderPlugin.createProgressiveUploadSession(videoObject.videoID);
      final video = await uploaderPlugin
          .uploadLastPart(videoObject.videoID, params.file.path, (a, b) {
        PercentageCalc.instance.currentValue = a;
        PercentageCalc.instance.finalValue = b;
        PercentageCalc.instance.setPercentage();
      });

      // var video = await ApiVideoMobileUploaderPlugin().uploadWithUploadToken(
      //     "to1kvsyehrFTNFYkKnq6TRTG", file.path, file.name, (a, b) {
      //   PercentageCalc.instance.currentValue = a;
      //   PercentageCalc.instance.finalValue = b;
      //   PercentageCalc.instance.setPercentage();
      // });
      return Video.fromJson(jsonDecode(video));
    } catch (e) {
      return null;
    }
  }

  // void createProgressiveVideoSession() {
  //   try {
  //     final progressiveSession =
  //         uploaderPlugin.createProgressiveUploadSession();
  //     return progressiveSession;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<VideoModel> createVideoObject(UploadLocalVideoParams file) async {
    try {
      final response = await http.post(
        Uri.parse(APIConstants.listVideos),
        body: jsonEncode({
          "title": file.title.isEmpty ? file.file.name : file.title,
          "description": file.description,
        }),
        headers: {'authorization': basicAuth},
      );
      final Map<String, dynamic> mappedData = jsonDecode(response.body);

      final videoModel = VideoModel(
        videoID: mappedData['videoId'],
        title: mappedData['title'],
        description: mappedData['description'],
        createdAt: DateTime.parse(mappedData['createdAt']),
        asset: VideoAsset(
          iFrame: mappedData['assets']['iframe'],
          player: mappedData['assets']['player'],
          videoUrl: mappedData['assets']['mp4'],
        ),
      );
      return videoModel;
    } catch (e) {
      rethrow;
    }
  }
}

class PercentageCalc {
  int currentValue = 0;
  int finalValue = 0;
  PercentageCalc._();
  static final _instance = PercentageCalc._();
  static PercentageCalc get instance => _instance;
  ValueNotifier percentage = ValueNotifier(0);

  reset() {
    currentValue = 0;
    finalValue = 0;
  }

  setPercentage() {
    percentage.value = ((currentValue / finalValue) * 100).toInt();
  }
}


//
