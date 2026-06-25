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

  /// [controller] 是否由本 widget 内部创建（并负责释放）
  bool _isInternalController = false;

  /// 由本 widget 内置手势添加的指针，
  /// 其 [AnimationController] 以本 [State] 作为 vsync，
  /// 必须在 [State] dispose 前清理，避免 active-ticker 泄漏。
  final Set<int> _ownPointerIds = <int>{};

  /// 本 widget 添加且仍存活的指针 id 集合（仅用于测试）。
  @visibleForTesting
  Set<int> get ownPointerIds => _ownPointerIds;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    final ShowTouchesController? external = widget.controller;
    _isInternalController = external == null;
    controller = external ?? ShowTouchesController();
  }

  @override
  void didUpdateWidget(ShowTouches oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.controller, oldWidget.controller)) {
      _disposeOwnedPointers();
      _initController();
    }
  }

  @override
  void dispose() {
    _disposeOwnedPointers();
    super.dispose();
  }

  /// 释放本 widget 拥有的指针。
  /// 仅内部创建的 [controller] 会被完整 dispose，
  /// 外部传入的 [controller] 保持有效，只移除此处添加的指针。
  void _disposeOwnedPointers() {
    if (_isInternalController) {
      controller.dispose();
    } else {
      for (final int pointerId in _ownPointerIds) {
        controller.disposePointer(pointerId);
      }
    }
    _ownPointerIds.clear();
  }

  void _addPointer(BuildContext context, int pointerId, Offset position) {
    final AnimationController animationController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: widget.showDuration,
      reverseDuration: widget.removeDuration,
    );
    _ownPointerIds.add(pointerId);

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
    controller.removePointer(
      pointerId: pointerId,
      onRemoved: () => _ownPointerIds.remove(pointerId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (BuildContext context) {
            final Widget child = widget.child ?? const SizedBox();
            final bool enable = widget.enable;
            return Listener(
              onPointerDown: enable
                  ? (event) =>
                      _addPointer(context, event.pointer, event.position)
                  : null,
              onPointerMove: enable
                  ? (event) => _updatePointer(event.pointer, event.position)
                  : null,
              onPointerUp:
                  enable ? (event) => _removePointer(event.pointer) : null,
              onPointerCancel:
                  enable ? (event) => _removePointer(event.pointer) : null,
              behavior: HitTestBehavior.translucent,
              child: child,
            );
          },
        ),
      ],
    );
  }
}
