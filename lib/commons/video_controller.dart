import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoController {
  VideoPlayerController? controller;
  bool _isFullScreen = false;
  bool _isMute = false;
  double? videoVolume;
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isInitilizedNotifier = ValueNotifier(false);
  final ValueNotifier<bool> areControlsVisible = ValueNotifier(true);

  // getter methods
  ValueNotifier<bool> get isPlayingNotifier => _isPlayingNotifier;
  ValueNotifier<bool> get isInitilizedNotifier => _isInitilizedNotifier;
  bool get isFullScreen => _isFullScreen;
  bool get isMute => _isMute;

  Future<bool> initializeController({
    required String videoUrl,
    double duration = 0.0,
    bool isPlaying = false,
    double volume = 10.0,
    bool isLocal = false,
  }) async {
    try {
      if (isLocal) {
        controller = VideoPlayerController.file(File(videoUrl));
      } else {
        controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      }
      await controller!.initialize();
      _isInitilizedNotifier.value = controller!.value.isInitialized;
      if (isPlaying) {
        await controller?.play();
      } else {
        await controller?.pause();
      }
      await controller?.seekTo(Duration(seconds: duration.toInt()));
      await controller?.setVolume(volume);
      controller!.addListener(_videoListeners);
      return true;
    } catch (e) {
      log('video controller initalizer issue $e');
      return false;
    }
  }

  void _videoListeners() {
    _playPauseListener();
  }

  Future<void> disposeController() async {
    _isInitilizedNotifier.value = false;
    controller?.removeListener(_videoListeners);
    await controller?.pause();
    await controller?.dispose();
    controller = null;
  }

  Future<void> playVideo() async {
    if (controller != null) {
      await controller?.play();
    }
  }

  Future<void> pauseVideo() async {
    if (controller != null) {
      await controller!.pause();
    }
  }

  Future<void> toggleVideo() async {
    if (controller != null) {
      if (controller!.value.isPlaying) {
        await controller!.pause();
      } else {
        await controller!.play();
      }
    }
  }

  Future<void> seekForward() async {
    if (controller != null) {
      await controller!.seekTo(
        controller!.value.position + const Duration(seconds: 10),
      );
    }
  }

  Future<void> seekBackward() async {
    if (controller != null) {
      await controller!.seekTo(
        controller!.value.position - const Duration(seconds: 10),
      );
    }
  }

  void toggleMute() {
    if (controller != null) {
      _isMute ? unMuteVideo() : muteVideo();
    }
  }

  Future<void> muteVideo() async {
    _isMute = true;
    videoVolume = controller!.value.volume;
    await controller!.setVolume(0);
  }

  Future<void> unMuteVideo() async {
    _isMute = false;
    await controller!.setVolume(videoVolume ?? 1);
    if (controller!.value.volume == 0) {
      await controller!.setVolume(0.1);
    }
  }

  Future<void> increaseVolume() async {
    final volume = controller!.value.volume + 0.1;
    await controller!.setVolume(volume);
  }

  Future<void> decreaseVolume() async {
    final volume = controller!.value.volume - 0.1;
    await controller!.setVolume(volume);
  }

  Future<void> setVolume(double newVolume) async {
    await controller!.setVolume(newVolume);
  }

  Future<void> setFullScreen(bool fullScreen) async {
    if (fullScreen) {
      await _enterFullScreen();
    } else {
      await _exitFullScreen();
    }
  }

  Future<void> _enterFullScreen() async {
    _isFullScreen = true;
    _setOrientationForVideo();
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  Future<void> _exitFullScreen() async {
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _isFullScreen = false;
  }

  void _setOrientationForVideo() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _playPauseListener() {
    if (controller?.value.isPlaying ?? false) {
      _isPlayingNotifier.value = true;
    } else {
      _isPlayingNotifier.value = false;
    }
  }
}
