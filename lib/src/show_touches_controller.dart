import 'package:flutter/widgets.dart';

import 'widget/default_builder.dart';

typedef TouchBuilder = Widget Function(
  BuildContext context,
  int pointerId,
  Offset position,
  Animation<double> animation,
);

class TouchData {
  const TouchData({
    required this.pointerId,
    required this.positionState,
    required this.animationController,
    this.overlayEntry,
  });

  final int pointerId;
  final ValueNotifier<Offset> positionState;
  final AnimationController animationController;
  final OverlayEntry? overlayEntry;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TouchData &&
        other.pointerId == pointerId &&
        other.positionState.hashCode == positionState.hashCode &&
        other.animationController.hashCode == animationController.hashCode &&
        other.overlayEntry.hashCode == overlayEntry.hashCode;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      pointerId,
      positionState,
      animationController,
      overlayEntry,
    ]);
  }
}

class ShowTouchesController {
  final Map<int, TouchData> _touchData = {};

  Map<int, TouchData> get data => _touchData;

  void addTouchOverlay({
    required BuildContext context,
    required int pointerId,
    required Offset position,
    required AnimationController animationController,
    TouchBuilder? builder,
  }) {
    if (_touchData.containsKey(pointerId)) return;

    animationController.forward();
    final ValueNotifier<Offset> positionState = ValueNotifier<Offset>(position);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<Offset>(
          valueListenable: positionState,
          builder: (
            BuildContext context,
            Offset currentPosition,
            Widget? child,
          ) {
            if (builder != null) {
              return builder(
                context,
                pointerId,
                currentPosition,
                animationController,
              );
            } else {
              return DefaultBuilder(
                position: currentPosition,
                animation: animationController,
              );
            }
          },
        );
      },
    );

    _touchData[pointerId] = TouchData(
      pointerId: pointerId,
      positionState: positionState,
      animationController: animationController,
      overlayEntry: overlayEntry,
    );

    Overlay.of(context).insert(overlayEntry);
  }

  void updateTouchOverlay({required int pointerId, required Offset position}) {
    if (!_touchData.containsKey(pointerId)) return;
    _touchData[pointerId]?.positionState.value = position;
  }

  void removeTouchOverlay({required int pointerId}) {
    final TouchData? touchData = _touchData[pointerId];
    _touchData.remove(pointerId);
    if (touchData != null) {
      final animationController = touchData.animationController;
      animationController.forward().whenCompleteOrCancel(() {
        animationController.reverse().whenCompleteOrCancel(() {
          touchData.animationController.dispose();
          touchData.positionState.dispose();
          touchData.overlayEntry
            ?..remove()
            ..dispose();
          _touchData.remove(pointerId);
        });
      });
    }
  }

  void disposeTouch(int pointerId) {
    final TouchData? touchData = _touchData[pointerId];
    touchData?.animationController.dispose();
    touchData?.positionState.dispose();
    touchData?.overlayEntry
      ?..remove()
      ..dispose();
    _touchData.remove(pointerId);
  }

  void dispose() {
    _touchData.forEach((_, touchData) => disposeTouch(touchData.pointerId));
  }
}
