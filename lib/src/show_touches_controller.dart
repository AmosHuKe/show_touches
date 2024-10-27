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
        other.positionState.hashCode == positionState.hashCode &&
        other.animationController.hashCode == animationController.hashCode &&
        other.pointerOverlayEntry.hashCode == pointerOverlayEntry.hashCode;
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

  /// All pointer data
  /// |
  /// 所有指针数据
  ///
  /// ```dart
  /// Map<pointerId, PointerData>
  /// ```
  Map<int, PointerData> get data => _pointerData;

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
  ///
  /// ------
  ///
  /// - [pointerId] : 指针（触摸）ID。
  void removePointer({required int pointerId}) {
    final PointerData? pointerData = _pointerData[pointerId];
    _pointerData.remove(pointerId);
    if (pointerData != null) {
      final animationController = pointerData.animationController;
      animationController.forward().whenCompleteOrCancel(() {
        animationController.reverse().whenCompleteOrCancel(() {
          pointerData.animationController.dispose();
          pointerData.positionState.dispose();
          pointerData.pointerOverlayEntry
            ?..remove()
            ..dispose();
          _pointerData.remove(pointerId);
        });
      });
    }
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
    final PointerData? pointerData = _pointerData[pointerId];
    pointerData?.animationController.dispose();
    pointerData?.positionState.dispose();
    pointerData?.pointerOverlayEntry
      ?..remove()
      ..dispose();
    _pointerData.remove(pointerId);
  }

  /// Dispose all pointers
  /// |
  /// dispose 所有指针
  void dispose() {
    final pointerData = List<MapEntry<int, PointerData>>.from(
      _pointerData.entries,
    );
    for (final MapEntry<int, PointerData> data in pointerData) {
      disposePointer(data.value.pointerId);
    }
  }
}
