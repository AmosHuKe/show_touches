import 'package:flutter/widgets.dart';

import '../config/default_pointer_style.dart';

/// DefaultPointerBuilder
/// |
/// 默认指针 Builder
class DefaultPointerBuilder extends StatefulWidget {
  /// DefaultPointerBuilder
  /// |
  /// 默认指针 Builder
  ///
  /// - [position]            : Current touch position.
  /// - [animation]           : [Animation]
  /// - [defaultPointerStyle] : Default style for the pointer widget.
  ///
  /// ------
  ///
  /// - [position]            : 当前触摸位置。
  /// - [animation]           : [Animation]
  /// - [defaultPointerStyle] : 默认的指针 Widget 样式。
  const DefaultPointerBuilder({
    super.key,
    required this.position,
    required this.animation,
    this.defaultPointerStyle = const DefaultPointerStyle(),
  });

  /// Current touch position.
  ///
  /// ------
  ///
  /// 当前触摸位置。
  final Offset position;

  final Animation<double> animation;

  /// Default style for the pointer widget.
  ///
  /// ------
  ///
  /// 默认的指针 Widget 样式。
  final DefaultPointerStyle defaultPointerStyle;

  @override
  State<DefaultPointerBuilder> createState() => _DefaultPointerBuilderState();
}

class _DefaultPointerBuilderState extends State<DefaultPointerBuilder> {
  /// 缓存视觉 widget，避免每次 build 都重新创建，导致动画重置。
  late Widget _visual;

  @override
  void initState() {
    super.initState();
    _visual = _buildVisual();
  }

  @override
  void didUpdateWidget(DefaultPointerBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation ||
        widget.defaultPointerStyle != oldWidget.defaultPointerStyle) {
      _visual = _buildVisual();
    }
  }

  Widget _buildVisual() {
    final double pointerSize = widget.defaultPointerStyle.size;
    final Animation<double> scaleAnimation = Tween<double>(
      begin: 2.0,
      end: 1.0,
    ).animate(widget.animation);

    return IgnorePointer(
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: widget.animation,
          child: Opacity(
            opacity: widget.defaultPointerStyle.opacity,
            child: Container(
              width: pointerSize,
              height: pointerSize,
              decoration: BoxDecoration(
                color: widget.defaultPointerStyle.backgroundColor,
                shape: BoxShape.circle,
                border: widget.defaultPointerStyle.border ??
                    Border.all(
                      width: 1.5,
                      color: const Color(0xFFFFFFFF),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double pointerSize = widget.defaultPointerStyle.size;
    return Positioned(
      left: widget.position.dx - pointerSize / 2.0,
      top: widget.position.dy - pointerSize / 2.0,
      child: RepaintBoundary(child: _visual),
    );
  }
}
