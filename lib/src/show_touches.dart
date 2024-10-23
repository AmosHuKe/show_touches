import 'package:flutter/widgets.dart';

class ShowTouches extends StatefulWidget {
  const ShowTouches({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ShowTouches> createState() => _ShowTouchesState();
}

class _ShowTouchesState extends State<ShowTouches>
    with TickerProviderStateMixin {
  final Map<int, TouchPosition> _overlayEntry = {};

  void _addTouchOverlay(int pointerId, Offset position) {
    if (_overlayEntry.containsKey(pointerId)) return;

    final AnimationController animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..forward();

    final positionNotifier = ValueNotifier<Offset>(position);

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<Offset>(
          valueListenable: positionNotifier,
          builder: (context, currentPosition, child) {
            return Positioned(
              left: positionNotifier.value.dx - 30,
              top: positionNotifier.value.dy - 30,
              child: IgnorePointer(
                ignoring: true,
                child: FadeTransition(
                  opacity: animationController,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    _overlayEntry[pointerId] = TouchPosition(
      pointerId: pointerId,
      positionNotifier: positionNotifier,
      animationController: animationController,
      overlayEntry: overlayEntry,
    );

    Overlay.of(context).insert(overlayEntry);
  }

  void _updateTouchOverlay(int pointerId, Offset position) {
    if (_overlayEntry.containsKey(pointerId)) {
      _overlayEntry[pointerId]!.positionNotifier.value = position;
    }
  }

  void _removeTouchOverlay(int pointerId) {
    final overlayEntry = _overlayEntry[pointerId];
    if (overlayEntry != null) {
      overlayEntry.animationController.reverse().then((_) {
        overlayEntry.overlayEntry?.remove();
        overlayEntry.animationController.dispose();
        overlayEntry.positionNotifier.dispose();
        _overlayEntry.remove(pointerId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _addTouchOverlay(event.pointer, event.localPosition);
      },
      onPointerMove: (event) {
        _updateTouchOverlay(event.pointer, event.localPosition);
      },
      onPointerUp: (event) {
        _removeTouchOverlay(event.pointer);
      },
      onPointerCancel: (event) {
        _removeTouchOverlay(event.pointer);
      },
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}

class TouchPosition {
  const TouchPosition({
    required this.pointerId,
    required this.positionNotifier,
    required this.animationController,
    this.overlayEntry,
  });

  final int pointerId;

  final ValueNotifier<Offset> positionNotifier;

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
    return other is TouchPosition &&
        other.pointerId == pointerId &&
        other.positionNotifier.value == positionNotifier.value &&
        other.animationController.toString() ==
            animationController.toString() &&
        other.overlayEntry.toString() == overlayEntry.toString();
  }

  @override
  int get hashCode {
    return Object.hashAll([
      pointerId,
      positionNotifier.value,
      animationController.toString(),
      overlayEntry.toString(),
    ]);
  }
}
