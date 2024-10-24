import 'package:flutter/widgets.dart';

import 'default_config/default_builder.dart';

typedef TouchBuilder = Widget Function(
  BuildContext context,
  int pointerId,
  Offset position,
  Animation<double> animation,
);

class ShowTouches extends StatefulWidget {
  const ShowTouches({
    super.key,
    required this.child,
    this.builder,
    this.showDuration = const Duration(milliseconds: 200),
    this.hideDuration = const Duration(milliseconds: 200),
  });

  final Widget child;

  final TouchBuilder? builder;

  final Duration showDuration;
  final Duration hideDuration;

  @override
  State<ShowTouches> createState() => _ShowTouchesState();
}

class _ShowTouchesState extends State<ShowTouches>
    with TickerProviderStateMixin {
  final Map<int, TouchData> _touchData = {};

  @override
  void dispose() {
    _touchData.forEach((_, touchData) => _dispose(touchData.pointerId));
    super.dispose();
  }

  void _dispose(int pointerId) {
    final TouchData? touchState = _touchData[pointerId];
    touchState?.animationController.dispose();
    touchState?.positionState.dispose();
    touchState?.overlayEntry
      ?..remove()
      ..dispose();
    _touchData.remove(pointerId);
  }

  void _addTouchOverlay(int pointerId, Offset position) {
    if (_touchData.containsKey(pointerId)) return;

    final AnimationController animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.showDuration,
      reverseDuration: widget.hideDuration,
    )..forward();

    final positionState = ValueNotifier<Offset>(position);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<Offset>(
          valueListenable: positionState,
          builder: (
            BuildContext context,
            Offset currentPosition,
            Widget? child,
          ) {
            if (widget.builder != null) {
              return widget.builder!(
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

  void _updateTouchOverlay(int pointerId, Offset position) {
    if (_touchData.containsKey(pointerId)) {
      _touchData[pointerId]?.positionState.value = position;
    }
  }

  void _removeTouchOverlay(int pointerId, Offset position) {
    final TouchData? touchState = _touchData[pointerId];
    if (touchState != null) {
      final animationController = touchState.animationController;
      animationController.forward().whenCompleteOrCancel(() {
        animationController.reverse().whenCompleteOrCancel(() {
          _dispose(pointerId);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _addTouchOverlay(event.pointer, event.position);
      },
      onPointerMove: (event) {
        _updateTouchOverlay(event.pointer, event.position);
      },
      onPointerUp: (event) {
        _removeTouchOverlay(event.pointer, event.position);
      },
      onPointerCancel: (event) {
        _removeTouchOverlay(event.pointer, event.position);
      },
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}

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
}
