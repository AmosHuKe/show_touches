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

class _ShowTouchesState extends State<ShowTouches> {
  final Map<int, TouchPosition> _overlayEntry = {};

  void _showTouchOverlay(int pointerId, Offset position) {
    final TouchPosition? touch = _overlayEntry[pointerId];
    if (touch != null) {
      if (touch.position != position) {
        touch.overlayEntry?.remove();
      } else {
        return;
      }
    }

    _overlayEntry[pointerId] = TouchPosition(
      pointerId: pointerId,
      position: position,
      overlayEntry: OverlayEntry(
        builder: (context) => Positioned(
          left: position.dx - 30,
          top: position.dy - 30,
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
    Overlay.of(context).insert(_overlayEntry[pointerId]!.overlayEntry!);
  }

  void _addTouchOverlay(int pointerId, Offset position) {
    _showTouchOverlay(pointerId, position);
  }

  void _updateTouchOverlay(int pointerId, Offset position) {
    _showTouchOverlay(pointerId, position);
  }

  void _removeTouchOverlay(int pointerId) {
    _overlayEntry[pointerId]?.overlayEntry?.remove();
    _overlayEntry.remove(pointerId);
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
      child: widget.child,
    );
  }
}

class TouchPosition {
  const TouchPosition({
    required this.pointerId,
    required this.position,
    this.overlayEntry,
  });

  final int pointerId;

  final Offset position;

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
        other.position == position &&
        other.overlayEntry.toString() == overlayEntry.toString();
  }

  @override
  int get hashCode {
    return Object.hashAll([
      pointerId,
      position,
      overlayEntry.toString(),
    ]);
  }
}
