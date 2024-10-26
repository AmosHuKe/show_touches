import 'package:flutter/widgets.dart';

import '../config/default_pointer_style.dart';

/// DefaultPointerBuilder
/// |
/// 默认指针 Builder
class DefaultPointerBuilder extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double pointerSize = defaultPointerStyle.size;
    final Animation<double> scaleAnimation = Tween<double>(
      begin: 2.0,
      end: 1.0,
    ).animate(animation);

    return Positioned(
      left: position.dx - pointerSize / 2.0,
      top: position.dy - pointerSize / 2.0,
      child: IgnorePointer(
        ignoring: true,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: animation,
            child: Opacity(
              opacity: defaultPointerStyle.opacity,
              child: Container(
                width: pointerSize,
                height: pointerSize,
                decoration: BoxDecoration(
                  color: defaultPointerStyle.backgroundColor,
                  shape: BoxShape.circle,
                  border: defaultPointerStyle.border ??
                      Border.all(
                        width: 1.5,
                        color: const Color(0xFFFFFFFF),
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
