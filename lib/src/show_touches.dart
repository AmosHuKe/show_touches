import 'package:flutter/widgets.dart';

import 'show_touches_controller.dart';
import 'config/default_pointer_style.dart';

/// Show Touches
class ShowTouches extends StatefulWidget {
  /// Show Touches
  /// |
  /// 显示触摸操作
  ///
  /// {@template showTouches.widget}
  ///
  /// - [enable]              : true (enable) | false (disable)
  /// - [controller]          : [ShowTouchesController] to control the pointer.
  /// - [pointerBuilder]      : Custom pointer widget, but it will cause the [defaultPointerStyle] to be invalid.
  /// - [defaultPointerStyle] : Default style for the pointer widget when [pointerBuilder] is not used.
  /// - [showDuration]        : Show animation duration (pointer).
  /// - [removeDuration]      : Remove animation duration (pointer).
  ///
  /// ------
  ///
  /// - [enable]              : true（启用）| false（禁用）
  /// - [controller]          : 通过 [ShowTouchesController] 来控制指针。
  /// - [pointerBuilder]      : 自定义指针 Widget，但会导致 [defaultPointerStyle] 失效。
  /// - [defaultPointerStyle] : 默认的指针 Widget 样式（在没有指定 [pointerBuilder] 的时候）。
  /// - [showDuration]        : 显示动画的持续时间（指针）。
  /// - [removeDuration]      : 移除动画的持续时间（指针）。
  ///
  /// {@endtemplate}
  const ShowTouches({
    super.key,
    this.child,
    this.enable = true,
    this.controller,
    this.pointerBuilder,
    this.defaultPointerStyle = const DefaultPointerStyle(),
    this.showDuration = const Duration(milliseconds: 50),
    this.removeDuration = const Duration(milliseconds: 200),
  });

  final Widget? child;

  /// true (enable) | false (disable)
  ///
  /// ------
  ///
  /// true（启用）| false（禁用）
  final bool enable;

  /// [ShowTouchesController] to control the pointer.
  ///
  /// ------
  ///
  /// 通过 [ShowTouchesController] 来控制指针。
  final ShowTouchesController? controller;

  /// Custom pointer widget, but it will cause the [defaultPointerStyle] to be invalid.
  ///
  /// ------
  ///
  /// 自定义指针 Widget，但会导致 [defaultPointerStyle] 失效。
  ///
  /// {@macro showTouches.PointerBuilder}
  final PointerBuilder? pointerBuilder;

  /// Default style for the pointer widget when [pointerBuilder] is not used.
  ///
  /// ------
  ///
  /// 默认的指针 Widget 样式（在没有指定 [pointerBuilder] 的时候）。
  final DefaultPointerStyle defaultPointerStyle;

  /// Show animation duration (pointer).
  ///
  /// ------
  ///
  /// 显示动画的持续时间（指针）。
  final Duration showDuration;

  /// Remove animation duration (pointer).
  ///
  /// ------
  ///
  /// 移除动画的持续时间（指针）。
  final Duration removeDuration;

  /// Init
  /// {@macro showTouches.widget}
  static TransitionBuilder init({
    Key? key,
    TransitionBuilder? builder,
    bool enable = true,
    ShowTouchesController? controller,
    PointerBuilder? pointerBuilder,
    DefaultPointerStyle defaultPointerStyle = const DefaultPointerStyle(),
    Duration showDuration = const Duration(milliseconds: 50),
    Duration removeDuration = const Duration(milliseconds: 200),
  }) {
    return (BuildContext context, Widget? child) {
      final Widget showTouches = ShowTouches(
        key: key,
        enable: enable,
        controller: controller,
        pointerBuilder: pointerBuilder,
        defaultPointerStyle: defaultPointerStyle,
        showDuration: showDuration,
        removeDuration: removeDuration,
        child: child,
      );
      return builder == null ? showTouches : builder(context, showTouches);
    };
  }

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

  void _addPointer(BuildContext context, int pointerId, Offset position) {
    final animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.showDuration,
      reverseDuration: widget.removeDuration,
    );

    controller.addPointer(
      context: context,
      pointerId: pointerId,
      position: position,
      animationController: animationController,
      pointerBuilder: widget.pointerBuilder,
      defaultPointerStyle: widget.defaultPointerStyle,
    );
  }

  void _updatePointer(int pointerId, Offset position) {
    controller.updatePointer(pointerId: pointerId, position: position);
  }

  void _removePointer(int pointerId) {
    controller.removePointer(pointerId: pointerId);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) return widget.child ?? const SizedBox();
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext context) {
            return Listener(
              onPointerDown: (event) =>
                  _addPointer(context, event.pointer, event.position),
              onPointerMove: (event) =>
                  _updatePointer(event.pointer, event.position),
              onPointerUp: (event) => _removePointer(event.pointer),
              onPointerCancel: (event) => _removePointer(event.pointer),
              behavior: HitTestBehavior.translucent,
              child: widget.child,
            );
          },
        ),
      ],
    );
  }
}
