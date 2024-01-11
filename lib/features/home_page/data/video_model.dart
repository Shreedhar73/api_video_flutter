class VideoModel {
  final String videoID;
  final String? title;
  final String? description;
  final DateTime? createdAt;
  final List<Chapter>? chapters;
  final VideoAsset? asset;

  VideoModel(
      {required this.videoID,
      this.title,
      this.description,
      this.createdAt,
      this.chapters,
      this.asset});
}

class VideoAsset {
  final String? iFrame;
  final String? player;
  final String? thumbnail;
  final String? videoUrl;

  VideoAsset({this.iFrame, this.player, this.thumbnail, this.videoUrl});
}

class Chapter {
  String title;
  String startTime;
  String endTime;

  Chapter({
    required this.title,
    required this.startTime,
    required this.endTime,
  });
}

List<Chapter> chaptersListFromJson(List<Map<String, dynamic>>? dataList) {
  final decodedData = dataList;
  return decodedData == null
      ? []
      : List<Chapter>.from(
          decodedData.map((e) => Chapter(
                title: e['text'],
                startTime: e['startTime'],
                endTime: e['endTime'],
              )),
          // decodedData.map(WikiSearchResultsModel.fromJson,)
        );
}
