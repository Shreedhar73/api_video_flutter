import 'dart:convert';

import 'package:api_video/commons/api.dart';
import 'package:api_video/commons/vtt_parser.dart';
import 'package:api_video/features/home_page/data/video_model.dart';
import 'package:http/http.dart' as http;
// import 'package:video_uploader/video_uploader.dart';

class ListAllVideos {
  String basicAuth =
      'Basic ${base64.encode(utf8.encode('ldu4FXvopcyxcNJa17Ziey0vMAn1vkJ52XgXUE7Ru1R:'))}';
  Future<List<VideoModel>?> getAllVideos() async {
    try {
      final dataList = <VideoModel>[];
      final response = await http.get(Uri.parse(APIConstants.listVideos),
          headers: {'authorization': basicAuth});
      final Map<String, dynamic> mappedData = jsonDecode(response.body);
      final jsonList = mappedData['data'] as List;
      for (var e in jsonList) {
        var chapterData = await getChapters(e['videoId']);
        dataList.add(VideoModel(
          videoID: e['videoId'],
          title: e['title'],
          description: e['description'],
          createdAt: DateTime.parse(e['createdAt']),
          chapters: chaptersListFromJson(chapterData),
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

  // get chapters file
  Future<List<Map<String, dynamic>>?> getChapters(String videoId) async {
    try {
      var vttUrl = '';
      String? vttData = '';
      var finalVttData = <Map<String, dynamic>>[];
      final chapters = await http.get(
          Uri.parse('${APIConstants.listVideos}/$videoId/chapters'),
          headers: {'authorization': basicAuth});
      // return chapters.body;
      final encodedData = jsonDecode(chapters.body)['data'];
      if (encodedData.isNotEmpty) {
        vttUrl = encodedData.first['src'].toString();
      }

      if (vttUrl.isNotEmpty) {
        vttData = await fetchVttContent(vttUrl);
      }

      if (vttData != null && vttData.isNotEmpty) {
        //parse vtt Data
        finalVttData = VttParser().parseVtt(vttData);
      }
      return finalVttData;
    } catch (e) {
      return null;
    }
  }

  Future<String?> fetchVttContent(String vttUrl) async {
    try {
      // Make an HTTP request to get the .vtt file content
      final response = await http.get(Uri.parse(vttUrl));

      if (response.statusCode == 200) {
        // Decode the response body as a string
        String vttContent = utf8.decode(response.bodyBytes);

        return vttContent;
      } else {
        // Handle the error if the request fails
        throw Exception('Failed to load .vtt file');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error: $e');
      return null;
    }
  }
}
