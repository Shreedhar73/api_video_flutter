import 'package:image_picker/image_picker.dart';

class PickALocalVideo {
  Future<XFile?>? pickAVideo() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
      );
      XFile? xfilePick = pickedFile;
      return xfilePick;
    } catch (e) {
      // throw Exception();
      return null;
    }
  }
}
