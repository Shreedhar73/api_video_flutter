class VideoModel {
  final String videoID;
  final String? title;
  final String? description;
  final DateTime? createdAt;
  final VideoAsset? asset;

  VideoModel(
      {required this.videoID,
      this.title,
      this.description,
      this.createdAt,
      this.asset});
}

class VideoAsset {
  final String? iFrame;
  final String? player;
  final String? thumbnail;
  final String? videoUrl;

  VideoAsset({this.iFrame, this.player, this.thumbnail, this.videoUrl});
}
