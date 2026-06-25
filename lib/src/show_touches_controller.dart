import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'config/default_pointer_style.dart';
import 'widget/default_pointer_builder.dart';

/// Pointer Builder
/// |
/// 指针 Builder
///
/// {@template showTouches.PointerBuilder}
///
/// - [context]   : [BuildContext]
/// - [pointerId] : Pointer (touch) ID.
/// - [position]  : Current touch position.
/// - [animation] : Animation to show and remove.
///
/// ------
///
/// - [context]   : [BuildContext]
/// - [pointerId] : 指针（触摸）ID。
/// - [position]  : 当前触摸位置。
/// - [animation] : 显示和移除的动画。
///
/// {@endtemplate}
typedef PointerBuilder = Widget Function(
  BuildContext context,
  int pointerId,
  Offset position,
  Animation<double> animation,
);

/// PointerData
class PointerData {
  /// PointerData
  /// |
  /// 指针数据
  ///
  /// - [pointerId]           : Pointer (touch) ID.
  /// - [positionState]       : Current touch position.
  /// - [animationController] : Animation controller.
  /// - [pointerOverlayEntry] : Pointer [OverlayEntry].
  ///
  /// ------
  ///
  /// - [pointerId]           : 指针（触摸）ID。
  /// - [positionState]       : 当前触摸位置。
  /// - [animationController] : 动画控制器。
  /// - [pointerOverlayEntry] : 指针 [OverlayEntry]。
  const PointerData({
    required this.pointerId,
    required this.positionState,
    required this.animationController,
    this.pointerOverlayEntry,
  });

  /// Pointer (touch) ID.
  ///
  /// ------
  ///
  /// 指针（触摸）ID。
  final int pointerId;

  /// Current touch position.
  ///
  /// ------
  ///
  /// 当前触摸位置。
  final ValueNotifier<Offset> positionState;

  /// Animation controller.
  ///
  /// ------
  ///
  /// 动画控制器。
  final AnimationController animationController;

  /// Pointer [OverlayEntry].
  ///
  /// ------
  ///
  /// 指针 OverlayEntry。
  final OverlayEntry? pointerOverlayEntry;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is PointerData &&
        other.pointerId == pointerId &&
        identical(other.positionState, positionState) &&
        identical(other.animationController, animationController) &&
        identical(other.pointerOverlayEntry, pointerOverlayEntry);
  }

  @override
  int get hashCode {
    return Object.hashAll([
      pointerId,
      positionState,
      animationController,
      pointerOverlayEntry,
    ]);
  }
}

class ShowTouchesController {
  /// All pointer data
  final Map<int, PointerData> _pointerData = {};

  /// Pointers currently running their removal animation.
  ///
  /// ------
  ///
  /// 正在执行移除动画的指针。
  final Set<int> _removingPointers = <int>{};

  /// Whether [dispose] has been called.
  ///
  /// ------
  ///
  /// 是否已调用 [dispose]。
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  /// All pointer data (read-only)
  ///
  /// ------
  ///
  /// 所有指针数据（只读）
  ///
  /// ```dart
  /// Map<pointerId, PointerData>
  /// ```
  Map<int, PointerData> get data => UnmodifiableMapView(_pointerData);

  /// Add Pointer
  /// |
  /// 添加指针
  ///
  /// - [pointerId]           : Pointer (touch) ID.
  /// - [position]            : Current touch position.
  /// - [animationController] : Animation controller.
  /// - [pointerBuilder]      : Custom pointer widget, but it will cause the [defaultPointerStyle] to be invalid.
  /// - [defaultPointerStyle] : Default style for the pointer widget when [pointerBuilder] is not used.
  ///
  /// ------
  ///
  /// - [pointerId]           : 指针（触摸）ID。
  /// - [position]            : 当前触摸位置。
  /// - [animationController] : 动画控制器。
  /// - [pointerBuilder]      : 自定义指针 Widget，但会导致 [defaultPointerStyle] 失效。
  /// - [defaultPointerStyle] : 默认的指针 Widget 样式（在没有指定 [pointerBuilder] 的时候）。
  void addPointer({
    required BuildContext context,
    required int pointerId,
    required Offset position,
    required AnimationController animationController,
    PointerBuilder? pointerBuilder,
    DefaultPointerStyle defaultPointerStyle = const DefaultPointerStyle(),
  }) {
    if (_pointerData.containsKey(pointerId)) return;

    animationController.forward();
    final ValueNotifier<Offset> positionState = ValueNotifier<Offset>(position);

    final pointerOverlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<Offset>(
          valueListenable: positionState,
          builder: (
            BuildContext context,
            Offset currentPosition,
            Widget? child,
          ) {
            if (pointerBuilder != null) {
              return pointerBuilder(
                context,
                pointerId,
                currentPosition,
                animationController,
              );
            } else {
              return DefaultPointerBuilder(
                position: currentPosition,
                animation: animationController,
                defaultPointerStyle: defaultPointerStyle,
              );
            }
          },
        );
      },
    );

    _pointerData[pointerId] = PointerData(
      pointerId: pointerId,
      positionState: positionState,
      animationController: animationController,
      pointerOverlayEntry: pointerOverlayEntry,
    );

    // ignore: invalid_null_aware_operator | Flutter >= 3.3.0
    Overlay.of(context)?.insert(pointerOverlayEntry);
  }

  /// Update Pointer
  /// |
  /// 更新指针
  ///
  /// - [pointerId] : Pointer (touch) ID.
  /// - [position]  : Current touch position.
  ///
  /// ------
  ///
  /// - [pointerId] : 指针（触摸）ID。
  /// - [position]  : 当前触摸位置。
  void updatePointer({required int pointerId, required Offset position}) {
    if (!_pointerData.containsKey(pointerId)) return;
    _pointerData[pointerId]?.positionState.value = position;
  }

  /// Remove Pointer
  /// |
  /// 移除指针
  ///
  /// - [pointerId] : Pointer (touch) ID.
  /// - [onRemoved] : Called after the pointer and its animation are fully removed.
  ///
  /// ------
  ///
  /// - [pointerId] : 指针（触摸）ID。
  /// - [onRemoved] : 指针（含动画）彻底移除后回调。
  void removePointer({required int pointerId, VoidCallback? onRemoved}) {
    final PointerData? pointerData = _pointerData[pointerId];
    if (pointerData == null) return;

    /// 防止重复移除（如抬起后又取消）在同一指针上叠加动画。
    if (!_removingPointers.add(pointerId)) return;

    final AnimationController animationController =
        pointerData.animationController;
    animationController.forward().whenCompleteOrCancel(() {
      /// 显示动画期间该指针可能已被 dispose，提前返回以避免释放后再使用。
      if (!_pointerData.containsKey(pointerId)) return;
      animationController.reverse().whenCompleteOrCancel(() {
        if (!_pointerData.containsKey(pointerId)) return;
        _disposePointerData(pointerData);
        _pointerData.remove(pointerId);
        _removingPointers.remove(pointerId);
        onRemoved?.call();
      });
    });
  }

  /// Dispose Pointer
  /// |
  /// dispose 指针
  ///
  /// - [pointerId] : Pointer (touch) ID.
  ///
  /// ------
  ///
  /// - [pointerId] : 指针（触摸）ID。
  void disposePointer(int pointerId) {
    /// 先移除，使进行中的移除动画回调短路，避免重复释放。
    final PointerData? pointerData = _pointerData.remove(pointerId);
    _removingPointers.remove(pointerId);
    if (pointerData == null) return;
    _disposePointerData(pointerData);
  }

  /// Dispose all pointers
  /// |
  /// dispose 所有指针
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    for (final int pointerId in _pointerData.keys.toList()) {
      disposePointer(pointerId);
    }
  }

  /// Release the resources held by a [PointerData]
  ///
  /// ------
  ///
  /// 释放 [PointerData] 持有的资源
  void _disposePointerData(PointerData pointerData) {
    pointerData.animationController.dispose();
    pointerData.positionState.dispose();
    pointerData.pointerOverlayEntry
      ?..remove()
      ..dispose();
  }
}
