import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_uploader/video_uploader.dart';

class UploadVideoDataSource {
  Future<Video?> uploadVideo(XFile file) async {
    try {
      PercentageCalc.instance.reset();
      var video = await ApiVideoUploader.uploadWithUploadToken(
          "to1kvsyehrFTNFYkKnq6TRTG", file.path, (a, b) {
        PercentageCalc.instance.currentValue = a;
        PercentageCalc.instance.finalValue = b;
        PercentageCalc.instance.setPercentage();
      });
      return video;
    } catch (e) {
      return null;
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
