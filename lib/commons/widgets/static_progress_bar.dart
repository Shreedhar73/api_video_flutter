import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StaticProgressBar extends StatelessWidget {
  const StaticProgressBar({
    required this.value,
    required this.barHeight,
    required this.handleHeight,
    this.latestDraggableOffset,
    super.key,
  });

  final Offset? latestDraggableOffset;
  final VideoPlayerValue value;

  final double barHeight;
  final double handleHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: CustomPaint(
        painter: _ProgressBarPainter(
          value: value,
          draggableValue: context.calcRelativePosition(
            value.duration,
            latestDraggableOffset,
          ),
          barHeight: barHeight,
          handleHeight: handleHeight,
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter({
    required this.value,
    required this.barHeight,
    required this.handleHeight,
    required this.draggableValue,
  });

  VideoPlayerValue value;

  final double barHeight;
  final double handleHeight;
  final Duration draggableValue;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final baseOffset = size.height / 2 - barHeight / 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0, baseOffset),
          Offset(size.width, baseOffset + barHeight),
        ),
        Radius.zero,
      ),
      Paint()
        ..color = const Color.fromRGBO(200, 200, 200, 0.5), // background color
    );
    if (!value.isInitialized) {
      return;
    }
    final playedPartPercent = (draggableValue != Duration.zero
            ? draggableValue.inMilliseconds
            : value.position.inMilliseconds) /
        value.duration.inMilliseconds;
    final playedPart =
        playedPartPercent > 1 ? size.width : playedPartPercent * size.width;
    for (final range in value.buffered) {
      final start = range.startFraction(value.duration) * size.width;
      final end = range.endFraction(value.duration) * size.width;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, baseOffset),
            Offset(end, baseOffset + barHeight),
          ),
          Radius.zero,
        ),
        Paint()..color = Colors.grey, // buffered part color
      );
    }
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(0, baseOffset),
            Offset(playedPart, baseOffset + barHeight),
          ),
          Radius.zero,
        ),
        Paint()..color = Colors.red, // played part color
      )
      ..drawCircle(
        Offset(playedPart, baseOffset + barHeight / 2),
        handleHeight,
        Paint()
          ..color =
              value.isPlaying ? Colors.transparent : Colors.red, // handle color
      );
  }
}

extension RelativePositionExtensions on BuildContext {
  Duration calcRelativePosition(
    Duration videoDuration,
    Offset? globalPosition,
  ) {
    if (globalPosition == null) return Duration.zero;
    final box = findRenderObject()! as RenderBox;
    final tapPos = box.globalToLocal(globalPosition);
    final relative = tapPos.dx / box.size.width;
    final position = videoDuration * relative;
    return position;
  }
}
