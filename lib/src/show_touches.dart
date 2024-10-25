import 'package:flutter/widgets.dart';

import 'show_touches_controller.dart';

class ShowTouches extends StatefulWidget {
  const ShowTouches({
    super.key,
    required this.child,
    this.controller,
    this.builder,
    this.showDuration = const Duration(milliseconds: 50),
    this.hideDuration = const Duration(milliseconds: 200),
  });

  final Widget child;

  final ShowTouchesController? controller;

  final TouchBuilder? builder;

  final Duration showDuration;
  final Duration hideDuration;

  @override
  State<ShowTouches> createState() => _ShowTouchesState();
}

class _ShowTouchesState extends State<ShowTouches>
    with TickerProviderStateMixin {
  late ShowTouchesController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ShowTouchesController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _addTouchOverlay(int pointerId, Offset position) {
    final AnimationController animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.showDuration,
      reverseDuration: widget.hideDuration,
    );

    controller.addTouchOverlay(
      context: context,
      pointerId: pointerId,
      position: position,
      animationController: animationController,
      builder: widget.builder,
    );
  }

  void _updateTouchOverlay(int pointerId, Offset position) {
    controller.updateTouchOverlay(pointerId: pointerId, position: position);
  }

  void _removeTouchOverlay(int pointerId) {
    controller.removeTouchOverlay(pointerId: pointerId);
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
