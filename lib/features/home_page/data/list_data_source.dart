import 'dart:convert';

import 'package:api_video/commons/api.dart';
import 'package:api_video/features/home_page/data/video_model.dart';
import 'package:http/http.dart' as http;
// import 'package:video_uploader/video_uploader.dart';

class ListAllVideos {
  String basicAuth =
      'Basic ${base64.encode(utf8.encode('ADSmXJUeHIlhSYn1RcjG0BtMfcr9RyeyzsAaL3GzsMA:'))}';
  Future<List<VideoModel>?> getAllVideos() async {
    try {
      final dataList = <VideoModel>[];
      final response = await http.get(Uri.parse(APIConstants.listVideos),
          headers: {'authorization': basicAuth});
      final Map<String, dynamic> mappedData = jsonDecode(response.body);
      final jsonList = mappedData['data'] as List;
      for (var e in jsonList) {
        dataList.add(VideoModel(
          videoID: e['videoId'],
          title: e['title'],
          description: e['description'],
          createdAt: DateTime.parse(e['createdAt']),
          asset: VideoAsset(
            iFrame: e['assets']['iframe'],
            player: e['assets']['player'],
            videoUrl: e['assets']['mp4'],
          ),
        ));
      }
      return dataList;
    } catch (e) {
      return null;
    }
  }
}
