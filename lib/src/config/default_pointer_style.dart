import 'package:flutter/widgets.dart';

/// DefaultPointerStyle
/// |
/// 默认指针样式
class DefaultPointerStyle {
  /// DefaultPointerStyle
  /// |
  /// 默认指针样式
  const DefaultPointerStyle({
    this.size = 30.0,
    this.opacity = 0.2,
    this.backgroundColor = const Color(0xFF525252),
    this.border,
  });

  final double size;
  final double opacity;
  final Color backgroundColor;
  final BoxBorder? border;

  DefaultPointerStyle copyWith({
    double? size,
    double? opacity,
    Color? backgroundColor,
    BoxBorder? border,
  }) {
    return DefaultPointerStyle(
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DefaultPointerStyle &&
        other.size == size &&
        other.opacity == opacity &&
        other.backgroundColor == backgroundColor &&
        other.border == border;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      size,
      opacity,
      backgroundColor,
      border,
    ]);
  }
}
