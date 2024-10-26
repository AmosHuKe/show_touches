import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:show_touches/show_touches.dart';

void main() {
  group('DefaultPointerStyle', () {
    test('copyWith', () {
      const DefaultPointerStyle style = DefaultPointerStyle();
      const DefaultPointerStyle styleExpect = DefaultPointerStyle(
        size: 99.0,
        opacity: 0.5,
        backgroundColor: Color(0xFFFFFFFF),
        border: Border(),
      );
      final DefaultPointerStyle styleCopyWith = style.copyWith(
        size: 99.0,
        opacity: 0.5,
        backgroundColor: const Color(0xFFFFFFFF),
        border: const Border(),
      );
      expect(style, style.copyWith());
      expect(styleCopyWith, styleExpect);
      expect(styleCopyWith.hashCode, styleExpect.hashCode);
    });
  });
}
